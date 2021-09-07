module Orchestrator
  module Terraform
    module Vars
      def self.create_import_maps_folder
        keys_path = "#{$project_vars['orchestrator']['orchestrator_path']}/vars/import_maps/#{$project_vars['terraform']['workspace']}"
        FileUtils.mkdir_p keys_path
        Orchestrator::ConsoleOutputs.info_message_item('Folder Created', keys_path)
      end

      def self.load_import_map(filename, workspace = ENV['TF_WORKSPACE'])
        require 'yaml'
        Orchestrator::ConsoleOutputs.sub_header_item('Loading Import Map', filename)
        # Orchestrator::ConsoleOutputs.debug_message_item('Orchestrator::Vars.File Name', file_name)
        file_path = "#{$project_vars['orchestrator']['orchestrator_path']}/vars/import_maps/#{workspace}/#{filename}.yml"
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Vars.yaml_vars] File Path', file_path)
        raise Orchestrator::ConsoleOutputs.error_message_item('[Orchestrator::Vars.yaml_vars] File Path Does Not Exist', file_path) unless File.exist?(file_path)

        import_vars = YAML.load_file(file_path)
        Orchestrator::ConsoleOutputs.debug_message_item('Map', import_vars)
        import_vars
      end

      def self.load_import_maps(workspace = ENV['TF_WORKSPACE'])
        require 'yaml'
        Orchestrator::ConsoleOutputs.sub_header('Loading Import Maps...')
        tf_roles = $project_vars['terraform']['roles']
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Vars.load_import_maps] TF Roles', tf_roles)
        $import_vars = Hash.new
        tf_roles.each do |role|
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Vars.load_import_maps] Role', role)
          file_path = "#{$project_vars['orchestrator']['orchestrator_path']}/vars/import_maps/#{workspace}/#{role}.yml"
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Vars.load_import_maps] File Path', file_path)
          next unless File.exist?(file_path)

          $import_vars[role] = YAML.load_file(file_path)
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Vars.load_import_maps] Maps', $import_vars[role])
        end
      end

      def self.show_common_vars
        common_vars = Orchestrator::Terraform::Cli.load_common_vars
        common_vars.each do |key, value|
          puts "#{key}: #{value}"
        end
      end

      def self.show_import_vars_single(file_name)
        Orchestrator::ConsoleOutputs.sub_header('Terraform Imported Map')
        import_map = Orchestrator::Vars.load_import_map(file_name)
        require 'json'
        puts JSON.pretty_generate(import_map).gsub(':', ' =>')
      end

      def self.show_import_vars
        Orchestrator::ConsoleOutputs.sub_header('Terraform Import Maps')
        require 'json'
        puts JSON.pretty_generate($import_vars).gsub(':', ' =>')
      end

      def self.show_import_var_keys
        Orchestrator::ConsoleOutputs.sub_header('Terraform Import Map Keys')
        puts $import_vars.keys
      end

      def self.local_version
        Orchestrator::Shell.run_command_strout('terraform --version | awk \'/^Terraform v[0-9]/ { print substr($2,2) }\'').strip
      end
    end
  end
end
