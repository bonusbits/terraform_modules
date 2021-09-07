module Orchestrator
  module Secrets
    module SecretsManager
      def self.display_value_as_json
        secret_name = $project_vars['secrets']['secrets_manager']['name']
        secret_hash = Orchestrator::AWS::SecretsManager.get_secret_json_to_hash(secret_name)
        require 'json'
        puts JSON.pretty_generate(secret_hash)
      end

      def self.display_value_as_hash
        secret_name = $project_vars['secrets']['secrets_manager']['name']
        secret_hash = Orchestrator::AWS::SecretsManager.get_secret_json_to_hash(secret_name)

        require 'pry'
        ::Pry::ColorPrinter.pp(secret_hash)
      end

      def self.upload_secrets
        secret_name = $project_vars['secrets']['secrets_manager']['name']
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Secrets::SecretsManager.upload_secrets] secret_name', secret_name)

        json_file = "#{$project_vars['orchestrator']['secrets_path']}/#{$project_vars['terraform']['workspace']}/secrets.json"
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Secrets::SecretsManager.upload_secrets] json_file', json_file)

        json_content = File.read(json_file)
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Secrets::SecretsManager.upload_secrets] json_content', json_content)

        Orchestrator::AWS::SecretsManager.upload_secrets_json(secret_name, json_content)
      end
    end
  end
end
