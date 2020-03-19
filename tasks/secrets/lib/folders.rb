module Orchestrator
  module Secrets
    module Folders
      def self.create_secrets_folders
        keys_path = "#{$project_vars['orchestrator']['secrets_path']}/#{$project_vars['terraform']['workspace']}"
        FileUtils.mkdir_p keys_path
        Orchestrator::ConsoleOutputs.info_message_item('Folder Created', keys_path)

        bastion_users_path = "#{$project_vars['orchestrator']['secrets_path']}/#{$project_vars['terraform']['workspace']}/bastion_users"
        FileUtils.mkdir_p bastion_users_path
        Orchestrator::ConsoleOutputs.info_message_item('Folder Created', bastion_users_path)

        ssh_configs_path = "#{$project_vars['orchestrator']['secrets_path']}/#{$project_vars['terraform']['workspace']}/bastion_ssh_configs"
        FileUtils.mkdir_p ssh_configs_path
        Orchestrator::ConsoleOutputs.info_message_item('Folder Created', ssh_configs_path)
      end
    end
  end
end
