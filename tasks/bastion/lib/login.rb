module Orchestrator
  module Bastion
    module Login
      def self.direct
        raise Orchestrator::ConsoleOutputs.error_message('Missing Rake Config bastion:login_user') if $project_vars['bastion']['login_user'].nil?
        raise Orchestrator::ConsoleOutputs.error_message('Missing Rake Config bastion:ssh_key_name') if $project_vars['bastion']['ssh_key_name'].nil?

        bastion_ip = Orchestrator::Bastion::Terraform.bastion_ip
        bastion_key_path = "#{$project_vars['orchestrator']['secrets_path']}/#{$project_vars['terraform']['workspace']}/#{$project_vars['bastion']['ssh_key_name']}"
        bastion_user_name = $project_vars['bastion']['login_user']
        system "ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i #{bastion_key_path} #{bastion_user_name}@#{bastion_ip}"
      end

      # TODO: WIP
      # def self.proxy_instance(type, instance_name, target_login_user = 'ubuntu')
      #   raise Orchestrator::ConsoleOutputs.error_message('Missing Rake Config bastion:login_user') if $project_vars['bastion']['login_user'].nil?
      #   raise Orchestrator::ConsoleOutputs.error_message('Missing Rake Config bastion:ssh_key_name') if $project_vars['bastion']['ssh_key_name'].nil?
      #
      #   Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Bastion::Login.proxy_instance] instance_name', instance_name)
      #
      #   key_path = "#{$project_vars['orchestrator']['secrets_path']}/#{$project_vars['terraform']['workspace']}"
      #   bastion_ip = Orchestrator::Bastion::Terraform.bastion_ip
      #   bastion_ssh_key = "#{key_path}/#{$project_vars['bastion']['ssh_key_name']}"
      #   # TODO: WIP
      #   case type
      #   when 'eks'
      #     private_ip = Orchestrator::Terraform::Fetch.pod_instance_ip(instance_name)
      #     private_ssh_key = "#{key_path}/eks"
      #   when 'ec2'
      #     private_ip = Orchestrator::Terraform::Fetch.ec2_instance_ip(instance_name)
      #     private_ssh_key = "#{key_path}/ec2"
      #   else
      #     raise Orchestrator::ConsoleOutputs.error_message('[Orchestrator::Bastion::Login.proxy_instance] Missing or Unknown Type')
      #   end
      #   Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Bastion::Login.proxy_instance] private_ssh_key', private_ssh_key)
      #   proxy_command = "ProxyCommand=\"ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -W %h:%p #{$project_vars['bastion']['login_user']}@#{bastion_ip} -i #{bastion_ssh_key}\""
      #   system("ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o #{proxy_command} #{target_login_user}@#{private_ip} -i #{private_ssh_key}")
      # end

      def self.proxy_ip(ip, ssh_key, bastion_user_name = $project_vars['bastion']['login_user'], host_user_name = $project_vars['bastion']['login_user'])
        raise Orchestrator::ConsoleOutputs.error_message('[Orchestrator::Bastion::Login.proxy_ip] Missing Rake Config bastion:login_user') if $project_vars['bastion']['login_user'].nil?
        raise Orchestrator::ConsoleOutputs.error_message('[Orchestrator::Bastion::Login.proxy_ip] Missing Rake Config bastion:ssh_key_name') if $project_vars['bastion']['ssh_key_name'].nil?

        key_path = "#{$project_vars['orchestrator']['secrets_path']}/#{$project_vars['terraform']['workspace']}"
        bastion_ip = Orchestrator::Bastion::Terraform.bastion_ip

        bastion_ssh_key = "#{key_path}/#{$project_vars['bastion']['ssh_key_name']}"
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Bastion::Login.proxy_ip] bastion_ssh_key', bastion_ssh_key)
        private_ip = ip

        private_ssh_key = "#{key_path}/#{ssh_key}"
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Bastion::Login.proxy_ip] private_ssh_key', private_ssh_key)

        proxy_command = "ProxyCommand=\"ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -W %h:%p #{bastion_user_name}@#{bastion_ip} -i #{bastion_ssh_key}\""
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Bastion::Login.proxy_ip] proxy_command', proxy_command)

        system("ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o #{proxy_command} #{host_user_name}@#{private_ip} -i #{private_ssh_key}")
      end
    end
  end
end
