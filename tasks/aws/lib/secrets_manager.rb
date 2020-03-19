module Orchestrator
  module AWS
    module SecretsManager
      def self.secrets_manager_client
        require 'aws-sdk-secretsmanager'

        Aws::SecretsManager::Client.new(
          region: $project_vars['aws']['region'],
          profile: $project_vars['aws']['profile']
        )
        # require 'aws-sdk-secretsmanager'
        # secrets_manager_client = Aws::SecretsManager::Client.new(region: 'us-east-1', profile: 'bonusbits')
      end

      def self.get_secret(secret_name)
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::SecretsManager.get_secret] secret_name', secret_name)

        secrets_manager_client = Orchestrator::AWS::SecretsManager.secrets_manager_client
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::SecretsManager.get_secret] secrets_manager_client', secrets_manager_client)

        # In this sample we only handle the specific exceptions for the 'GetSecretValue' API.
        # See https://docs.aws.amazon.com/secretsmanager/latest/apireference/API_GetSecretValue.html
        # We rethrow the exception by default.
        begin
          retries ||= 0
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::SecretsManager.get_secret] retries', retries)
          get_secret_value_response = secrets_manager_client.get_secret_value(secret_id: secret_name)
        rescue Aws::SecretsManager::Errors::DecryptionFailure => e
          Orchestrator::ConsoleOutputs.error_message_item('[Orchestrator::AWS::SecretsManager.get_secret] DecryptionFailure', e)
          raise
        rescue Aws::SecretsManager::Errors::InternalServiceError => e
          Orchestrator::ConsoleOutputs.error_message_item('[Orchestrator::AWS::SecretsManager.get_secret] InternalServiceError', e)
          raise
        rescue Aws::SecretsManager::Errors::InvalidParameterException => e
          Orchestrator::ConsoleOutputs.error_message_item('[Orchestrator::AWS::SecretsManager.get_secret] InvalidParameterException', e)
          raise
        rescue Aws::SecretsManager::Errors::InvalidRequestException => e
          Orchestrator::ConsoleOutputs.error_message_item('[Orchestrator::AWS::SecretsManager.get_secret] InvalidRequestException', e)
          raise
        rescue Aws::SecretsManager::Errors::ResourceNotFoundException => e
          Orchestrator::ConsoleOutputs.error_message_item('[Orchestrator::AWS::SecretsManager.get_secret] ResourceNotFoundException', e)
          raise
        rescue StandardError => e
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::SecretsManager.get_secret]  Standard Error', e)
          Orchestrator::ConsoleOutputs.error_message_item('[Orchestrator::AWS::SecretsManager.get_secret] - Rescue', retries)
          sleep 1
          retry if (retries += 1) < 10
        else
          # Decrypts secret using the associated KMS CMK.
          # Depending on whether the secret is a string or binary, one of these fields will be populated.
          if get_secret_value_response.secret_string
            secret = get_secret_value_response.secret_string
          else
            require 'base64'
            secret = Base64.decode64(get_secret_value_response.secret_binary)
          end
        end
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::SecretsManager.get_secret] Return', secret)
        secret
      end

      def self.get_secret_json_to_hash(secret_name)
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::SecretsManager.get_secret_json_to_hash] secret_name', secret_name)
        secret = Orchestrator::AWS::SecretsManager.get_secret(secret_name)

        require 'json'
        secret_hash = JSON.parse(secret)
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::SecretsManager.get_secret_json_to_hash] Class', secret_hash.class)
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::SecretsManager.get_secret_json_to_hash] Return', secret_hash)
        secret_hash
      end

      def self.upload_secrets_json(secret_name, secret_value)
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::SecretsManager.upload_secrets_json] secret_name', secret_name)

        secrets_manager_client = Orchestrator::AWS::SecretsManager.secrets_manager_client
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::SecretsManager.upload_secrets_json] secrets_manager_client', secrets_manager_client)

        # In this sample we only handle the specific exceptions for the 'GetSecretValue' API.
        # See https://docs.aws.amazon.com/secretsmanager/latest/apireference/API_GetSecretValue.html
        # We rethrow the exception by default.
        begin
          retries ||= 0
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::SecretsManager.upload_secrets_json] retries', retries)
          secrets_manager_client.put_secret_value({
                                                    secret_id: secret_name,
                                                    secret_string: secret_value
                                                  })
        rescue Aws::SecretsManager::Errors::DecryptionFailure => e
          Orchestrator::ConsoleOutputs.error_message_item('[Orchestrator::AWS::SecretsManager.upload_secrets_json] DecryptionFailure', e)
          raise
        rescue Aws::SecretsManager::Errors::InternalServiceError => e
          Orchestrator::ConsoleOutputs.error_message_item('[Orchestrator::AWS::SecretsManager.upload_secrets_json] InternalServiceError', e)
          raise
        rescue Aws::SecretsManager::Errors::InvalidParameterException => e
          Orchestrator::ConsoleOutputs.error_message_item('[Orchestrator::AWS::SecretsManager.upload_secrets_json] InvalidParameterException', e)
          raise
        rescue Aws::SecretsManager::Errors::InvalidRequestException => e
          Orchestrator::ConsoleOutputs.error_message_item('[Orchestrator::AWS::SecretsManager.upload_secrets_json] InvalidRequestException', e)
          raise
        rescue Aws::SecretsManager::Errors::ResourceNotFoundException => e
          Orchestrator::ConsoleOutputs.error_message_item('[Orchestrator::AWS::SecretsManager.upload_secrets_json] ResourceNotFoundException', e)
          raise
        rescue StandardError => e
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::SecretsManager.upload_secrets_json]  Standard Error', e)
          Orchestrator::ConsoleOutputs.error_message_item('[Orchestrator::AWS::SecretsManager.upload_secrets_json] - Rescue', retries)
          sleep 1
          retry if (retries += 1) < 10
        else
          Orchestrator::ConsoleOutputs.message_item('Secret Uploaded!', secret_name)
        end
      end
    end
  end
end
