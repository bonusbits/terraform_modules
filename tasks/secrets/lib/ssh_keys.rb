module Orchestrator
  module Secrets
    module SshKeys
      def self.create_rsa_key(key_name, keys_path)
        if File.exist?("#{keys_path}/#{key_name}")
          Orchestrator::ConsoleOutputs.info_message_item('Already Created', "#{keys_path}/#{key_name}")
        else
          Orchestrator::ConsoleOutputs.info_message_item('Creating...', "#{keys_path}/#{key_name}")
          system "ssh-keygen -q -t rsa -m pem -b 4096 -N '' -f #{keys_path}/#{key_name}"
        end
      end

      def self.convert_rsa_key_to_pem(key_name, keys_path)
        if File.exist?("#{keys_path}/#{key_name}")
          Orchestrator::ConsoleOutputs.info_message_item('Already Created', "#{keys_path}/#{key_name}")
        else
          Orchestrator::ConsoleOutputs.info_message_item('Creating...', "#{keys_path}/#{key_name}")
          system "ssh-keygen -p -q -N '' -m pem -f #{keys_path}/#{key_name}"
        end
      end

      # Secrets Manager - Create SSH Keys from Content in Secrets Manager secret
      # rubocop
      def self.get_ssh_keys(overwrite = false)
        secret_name = $project_vars['secrets']['secrets_manager']['name']
        secret_hash = Orchestrator::AWS::SecretsManager.get_secret_json_to_hash(secret_name)

        $ssh_keys = Hash.new
        $ssh_keys = $ssh_keys.merge(secret_hash[$project_vars['terraform']['workspace']]['ssh_keys'])

        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Secrets::SshKeys.get_ssh_keys] ssh_keys', $ssh_keys)

        $ssh_keys.each do |key, values|
          private_key_path = "#{$project_vars['orchestrator']['secrets_path']}/#{$project_vars['terraform']['workspace']}/#{key}"
          public_key_path = "#{$project_vars['orchestrator']['secrets_path']}/#{$project_vars['terraform']['workspace']}/#{key}.pub"

          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Secrets::SshKeys.get_ssh_keys] private_key_path', private_key_path)
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Secrets::SshKeys.get_ssh_keys] public_key_path', public_key_path)

          if File.exist?(private_key_path) && overwrite || !File.exist?(private_key_path)
            File.open(private_key_path, 'w') do |f|
              f.write values['private']
              File.chmod(0o600, private_key_path)
              Orchestrator::ConsoleOutputs.message_item('File Created', private_key_path)
            end
          else
            Orchestrator::ConsoleOutputs.message_item('File Already Exists', private_key_path)
          end

          if File.exist?(public_key_path) && overwrite || !File.exist?(public_key_path)
            File.open(public_key_path, 'w') do |f|
              f.write values['public']
              File.chmod(0o644, public_key_path)
              Orchestrator::ConsoleOutputs.message_item('File Created', public_key_path)
            end
          else
            Orchestrator::ConsoleOutputs.message_item('File Already Exists', private_key_path)
          end
        end
      end
    end
  end
end
