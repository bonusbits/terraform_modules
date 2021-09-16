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

      # TODO: WIP

      #
      # = SecretsManager -- Generate Secrets JSON File
      #
      # == Purpose
      #
      # Creates a secrets.json file in the $TF_WORKSPACE secrets folder locally
      #
      # A very simple example is this:
      #
      #   require 'erb'
      #
      #   x = 42
      #   template = ERB.new <<-EOF
      #     The value of x is: <%= x %>
      #   EOF
      #   puts template.result(binding)
      #
      # <em>Prints:</em> The value of x is: 42
      #
      # More complex examples are given below.
      def self.generate_secrets_json(ssh_key_list = %w[bastion eks], overwrite = true)
        secret_name = $project_vars['secrets']['secrets_manager']['name']
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Secrets::SecretsManager.upload_secrets] secret_name', secret_name)

        json_file = "#{$project_vars['orchestrator']['secrets_path']}/#{$project_vars['terraform']['workspace']}/secrets.json"
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Secrets::SecretsManager.upload_secrets] json_file', json_file)

        erb_template_variables_map = Hash.new
        erb_template_variables_map['ssh_keys'] = Hash.new
        local_ssh_key_path = "#{$project_vars['orchestrator']['orchestrator_path']}/vars/secrets/#{$project_vars['terraform']['workspace']}"
        ssh_key_list.each do |ssh_key|
          erb_template_variables_map['ssh_keys'][ssh_key] = Hash.new
          erb_template_variables_map['ssh_keys'][ssh_key]['private'] = File.read("#{local_ssh_key_path}/#{ssh_key}")
          erb_template_variables_map['ssh_keys'][ssh_key]['public'] = File.read("#{local_ssh_key_path}/#{ssh_key}.pub")
        end

        template_file = "#{$project_vars['orchestrator']['orchestrator_path']}/templates/secrets_manager/secrets.json.erb"
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Secrets::SecretsManager.generate_secrets_json] template_file', template_file)

        # rendered_template = Orchestrator::Erb.render_template(template_file, erb_template_variables_map)

        if File.exist?(json_file) && overwrite || !File.exist?(json_file)
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Secrets::SecretsManager.generate_secrets_json] json_file', json_file)
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Secrets::SecretsManager.generate_secrets_json] template_file', template_file)
          Orchestrator::Erb.create_file(json_file, 0o644, template_file, erb_template_variables_map)
        else
          Orchestrator::ConsoleOutputs.message_item('File Already Exists', json_file)
        end
      end

      def self.upload_secrets(json_file = "#{$project_vars['orchestrator']['secrets_path']}/#{$project_vars['terraform']['workspace']}/secrets.json")
        secret_name = $project_vars['secrets']['secrets_manager']['name']
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Secrets::SecretsManager.upload_secrets] secret_name', secret_name)

        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Secrets::SecretsManager.upload_secrets] json_file', json_file)

        json_content = File.read(json_file)
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Secrets::SecretsManager.upload_secrets] json_content', json_content)

        Orchestrator::AWS::SecretsManager.upload_secrets_json(secret_name, json_content)
      end
    end
  end
end
