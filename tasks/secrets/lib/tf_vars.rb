module Orchestrator
  module Secrets
    module TfVars
      # Secrets Manager - Create Secrets TFVars from Content in Secrets Manager secret
      def self.get_secrets_tfvars(overwrite = false)
        secret_name = $project_vars['secrets']['secrets_manager']['name']
        secret_hash = Orchestrator::AWS::SecretsManager.get_secret_json_to_hash(secret_name)

        $secrets_tfvars = Hash.new
        $secrets_tfvars = $secrets_tfvars.merge(secret_hash[$project_vars['terraform']['workspace']]['tfvars'])

        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Secrets::TfVars.get_secrets_tfvars] secrets_tfvars', $secrets_tfvars)

        $secrets_tfvars.each do |key, _values|
          template_path = "#{$project_vars['orchestrator']['orchestrator_path']}/tasks/#{$project_vars['orchestrator']['environment']}/templates/tfvars/#{key}.tfvars.erb"
          file_path = "#{$project_vars['orchestrator']['secrets_path']}/#{$project_vars['terraform']['workspace']}/#{key}.tfvars"

          if File.exist?(file_path) && overwrite || !File.exist?(file_path)
            Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Secrets::TfVars.get_secrets_tfvars] file_path', file_path)
            Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Secrets::TfVars.get_secrets_tfvars] template_path', template_path)
            Orchestrator::Erb.create_file(file_path, 0o644, template_path, $secrets_tfvars)
          else
            Orchestrator::ConsoleOutputs.message_item('File Already Exists', file_path)
          end
        end
      end
    end
  end
end
