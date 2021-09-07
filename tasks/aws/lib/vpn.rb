module Orchestrator
  module AWS
    module VPN
      def self.stage_easy_rsa
        local_tmp_path = "#{$project_vars['orchestrator']['secrets_path']}/#{$project_vars['terraform']['workspace']}"
        system("mkdir -p #{local_tmp_path}")
        easy_rsa_path = "#{local_tmp_path}/easy-rsa/easyrsa3"
        if File.exist?(easy_rsa_path)
          Orchestrator::ConsoleOutputs.message('Easy RSA Already Cloned')
        else
          Orchestrator::ConsoleOutputs.message('Cloning...')
          system("git clone https://github.com/OpenVPN/easy-rsa.git #{local_tmp_path}")
        end

        if File.exist?("#{easy_rsa_path}/pki/ca.crt")
          Orchestrator::ConsoleOutputs.message('Easy RSA Already Initialized')
        else
          Orchestrator::ConsoleOutputs.message('Initializing...')
          command_list = [
            # Init PKI
            './easyrsa init-pki',
            # Build Certificate Authority
            './easyrsa build-ca nopass'
          ]

          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::VPN.stage_easy_rsa] Command List', command_list)

          Dir.chdir(easy_rsa_path) do
            command_list.each do |command|
              Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::VPN.create_server_certificates] Executing Command', command)
              system(command)
            end
          end
        end
      end

      def self.create_server_certificates
        Orchestrator::AWS::VPN.stage_easy_rsa
        local_tmp_path = "#{$project_vars['orchestrator']['secrets_path']}/#{$project_vars['terraform']['workspace']}"
        easy_rsa_path = "#{local_tmp_path}/easy-rsa/easyrsa3"
        root_domain = 'vpn.bonusbits.com'
        server_cert_dns = "server.#{$project_vars['terraform']['workspace']}.#{root_domain}"
        client_cert_dns = "client.#{$project_vars['terraform']['workspace']}.#{root_domain}"

        command_list = [
          # Build Server Certificate
          "./easyrsa build-server-full #{server_cert_dns} nopass",
          # Build Client Certificate
          "./easyrsa build-client-full #{client_cert_dns} nopass",
          # Output certs and key files
          'find . | egrep ".key|.crt"'
        ]

        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::VPN.create_server_certificates] Command List', command_list)

        Dir.chdir(easy_rsa_path) do
          command_list.each do |command|
            Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::VPN.create_server_certificates] Executing Command', command)
            system(command)
          end
        end
      end

      def self.upload_server_certificates
        local_tmp_path = "#{$project_vars['orchestrator']['secrets_path']}/#{$project_vars['terraform']['workspace']}"
        easy_rsa_path = "#{local_tmp_path}/easy-rsa/easyrsa3"
        root_domain = 'vpn.bonusbits.com'
        server_cert_dns = "server.#{$project_vars['terraform']['workspace']}.#{root_domain}"
        client_cert_dns = "client.#{$project_vars['terraform']['workspace']}.#{root_domain}"

        command_list = [
          # Upload to AWS Certificate Manager (ACM)
          ## Server
          "aws acm import-certificate --region #{$project_vars['aws']['region']} --profile #{$project_vars['aws']['profile']} --certificate fileb://pki/issued/#{server_cert_dns}.crt --private-key fileb://pki/private/#{server_cert_dns}.key --certificate-chain fileb://pki/ca.crt",
          ## Client
          "aws acm import-certificate --region #{$project_vars['aws']['region']} --profile #{$project_vars['aws']['profile']} --certificate fileb://pki/issued/#{client_cert_dns}.crt --private-key fileb://pki/private/#{client_cert_dns}.key --certificate-chain fileb://pki/ca.crt",

          # Upload to SSM
          ## CA
          "aws ssm put-parameter --name /#{$project_vars['terraform']['workspace']}/vpn/crt/ca --value \"$(cat pki/ca.crt | base64)\" --type SecureString --region #{$project_vars['aws']['region']} --profile #{$project_vars['aws']['profile']} --overwrite",
          ## Private
          "aws ssm put-parameter --name /#{$project_vars['terraform']['workspace']}/vpn/key/ca --value \"$(cat pki/private/ca.key | base64)\" --type SecureString --region #{$project_vars['aws']['region']} --profile #{$project_vars['aws']['profile']} --overwrite"
        ]

        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::VPN.upload_server_certificates] Command List', command_list)

        Dir.chdir(easy_rsa_path) do
          command_list.each do |command|
            Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::VPN.upload_server_certificates] Executing Command', command)
            system(command)
          end
        end
      end

      def self.create_user_certs(username)
        # Orchestrator::AWS::VPN.stage_easy_rsa

        local_secrets_path = "#{$project_vars['orchestrator']['secrets_path']}/#{$project_vars['terraform']['workspace']}"
        easy_rsa_path = "#{local_secrets_path}/easy-rsa/easyrsa3"

        command = <<-CLIENTCERTS
        export EASYRSA_BATCH=1

        username="#{username}"
        cert_domain="#{$project_vars['terraform']['workspace']}.vpn.bonusbits.com"
        cert_fqdn="${username}.${cert_domain}"

        ./easyrsa build-client-full ${cert_fqdn} nopass

        aws acm import-certificate \
            --certificate fileb://pki/issued/${cert_fqdn}.crt \
            --private-key fileb://pki/private/${cert_fqdn}.key \
            --certificate-chain fileb://pki/ca.crt
        CLIENTCERTS

        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::VPN.create_client_certs] Command', command)

        Dir.chdir(easy_rsa_path) do
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::VPN.create_client_certs] Executing Command', command)
          system(command)
        end
      end

      def self.create_user_config(username)
        # Orchestrator::AWS::VPN.stage_easy_rsa

        local_secrets_path = "#{$project_vars['orchestrator']['secrets_path']}/#{$project_vars['terraform']['workspace']}"
        easy_rsa_path = "#{local_secrets_path}/easy-rsa/easyrsa3"

        vpn_endpoint_id = Orchestrator::Terraform::Fetch.vpn_endpoint_id

        command = <<-CLIENTCONFIG
        export EASYRSA_BATCH=1

        username="#{username}"
        cert_domain="#{$project_vars['terraform']['workspace']}.vpn.bonusbits.com"
        cert_fqdn="${username}.${cert_domain}"
        outfile="#{local_secrets_path}/${username}-cvpn-endpoint.ovpn"

        aws ec2 export-client-vpn-client-configuration \
            --client-vpn-endpoint-id #{vpn_endpoint_id} \
            --output text >| $outfile

        sed -i~ "s/^remote /remote ${username}./" $outfile
        echo "<cert>"                      >> $outfile
        cat pki/issued/${cert_fqdn}.crt  >> $outfile
        echo "</cert>"                     >> $outfile
        echo "<key>"                       >> $outfile
        cat pki/private/${cert_fqdn}.key >> $outfile
        echo "</key>"                      >> $outfile

        echo "Created: $outfile"
        CLIENTCONFIG

        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::VPN.create_client_config] Command', command)

        Dir.chdir(easy_rsa_path) do
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::VPN.create_client_config] Executing Command', command)
          system(command)
        end
      end
    end
  end
end
