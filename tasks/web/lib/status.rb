module Orchestrator
  module Web
    module Status
      # Returns HTTP Status Code
      def self.http_code_local(url)
        require 'net/https'
        require 'uri'

        response = Net::HTTP.get_response(URI(url))
        response.code
      end

      # Returns Boolean Response if HTTP OK
      def self.http_ok_local(url)
        require 'net/https'
        require 'uri'

        response = Net::HTTP.get_response(URI(url))
        response.is_a?(Net::HTTPOK)
      end

      # Returns HTTP Status Code from Bastion Instance
      def self.http_code_bastion(url)
        command = "curl -s -o /dev/null -w \"%{http_code}\" #{url} && echo ''" # rubocop:disable Style/FormatStringToken
        bastion_ip = Orchestrator::Terraform::Fetch.bastion_ip
        key_path = "#{$project_vars['orchestrator']['secrets_path']}/#{$project_vars['terraform']['workspace']}/#{$project_vars['bastion']['ssh_key_name']}"
        Orchestrator::Ssh.run_command(bastion_ip, $project_vars['bastion']['login_user'], key_path, command)
      end
    end
  end
end
