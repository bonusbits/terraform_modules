module Orchestrator
  module Vars
    # Defaults to Environment Vars, but can be overridden
    # Because there is a limit to method args I've set it to one arg map of vars. This is for pre-defined environments (not using environment variables)
    def self.env_vars(env_var_overrides_map = {})
      # AWS Profile
      if env_var_overrides_map['aws'].nil? || env_var_overrides_map['aws']['profile'].nil?
        raise Orchestrator::ConsoleOutputs.error_message_item('Missing Environment Variable!', 'AWS_PROFILE') if ENV['AWS_PROFILE'].nil?

        aws_profile = ENV['AWS_PROFILE']
      else
        aws_profile = env_var_overrides_map['aws']['profile']
      end

      # AWS Region
      if env_var_overrides_map['aws'].nil? || env_var_overrides_map['aws']['region'].nil?
        raise Orchestrator::ConsoleOutputs.error_message_item('Missing Environment Variable!', 'AWS_REGION') if ENV['AWS_REGION'].nil?

        aws_region = ENV['AWS_REGION']
      else
        aws_region = env_var_overrides_map['aws']['region']
      end

      # Kubeconfig
      kubernetes_config_path = if env_var_overrides_map['kubernetes'].nil? || env_var_overrides_map['kubernetes']['config_path'].nil?
                                 # raise Orchestrator::ConsoleOutputs.error_message_item('Missing Environment Variable!', 'KUBECONFIG') if ENV['KUBECONFIG'].nil?

                                 ENV['KUBECONFIG']
                               else
                                 env_var_overrides_map['kubernetes']['config_path']
                               end

      # Terraform Workspace
      if env_var_overrides_map['terraform'].nil? || env_var_overrides_map['terraform']['workspace'].nil?
        raise Orchestrator::ConsoleOutputs.error_message_item('Missing Environment Variable!', 'TF_WORKSPACE') if ENV['TF_WORKSPACE'].nil?

        terraform_workspace = ENV['TF_WORKSPACE'].downcase
      else
        terraform_workspace = env_var_overrides_map['terraform']['workspace'].downcase
      end

      # Terraform Plugin Cache
      if env_var_overrides_map['terraform'].nil? || env_var_overrides_map['terraform']['plugin_cache_dir'].nil?
        raise Orchestrator::ConsoleOutputs.error_message_item('Missing Environment Variable!', 'TF_PLUGIN_CACHE_DIR') if ENV['TF_PLUGIN_CACHE_DIR'].nil?

        terraform_plugin_cache_dir = ENV['TF_PLUGIN_CACHE_DIR']
      else
        terraform_plugin_cache_dir = env_var_overrides_map['terraform']['plugin_cache_dir']
      end

      # $project_vars = Hash.new # Done in Rakefile
      $project_vars['terraform'] = Hash.new
      $project_vars['terraform']['workspace'] = terraform_workspace
      $project_vars['terraform']['plugin_cache_dir'] = terraform_plugin_cache_dir
      $project_vars['aws'] = Hash.new
      $project_vars['aws']['region'] = aws_region
      $project_vars['aws']['profile'] = aws_profile
      $project_vars['kubernetes'] = Hash.new
      $project_vars['kubernetes']['config_path'] = kubernetes_config_path
      $project_vars['orchestrator']['secrets_path'] = "#{$project_vars['orchestrator']['orchestrator_path']}/vars/secrets"
    end

    def self.yaml_vars(workspace = ENV.fetch('TF_WORKSPACE'))
      # Can't use debug variable option because it's not loaded yet. It is loaded by this method
      require 'yaml'
      require 'deep_merge'
      # puts "[Orchestrator::Vars.yaml_vars] #{workspace}"
      yaml_file = workspace
      orchestrator_config = "#{$project_vars['orchestrator']['orchestrator_path']}/vars/orchestrator/#{yaml_file.downcase}.yml"

      # puts "[Orchestrator::Vars.yaml_vars] #{orchestrator_config}"
      raise Orchestrator::ConsoleOutputs.error_message_item('Orchestrator Config Missing', orchestrator_config) unless File.exist?(orchestrator_config)

      yaml_hash = YAML.load_file(orchestrator_config)
      $project_vars.deep_merge(yaml_hash)
    end

    def self.show_vars
      Orchestrator::ConsoleOutputs.sub_header_item('Project Variables', '$project_vars[]')
      $project_vars.each do |key, value|
        puts "#{key}: #{value}"
      end
    end

    def self.orchestrator_version
      require 'yaml'
      version_file = "#{$project_vars['orchestrator']['orchestrator_path']}/version.yml"
      versions = YAML.load_file(version_file)
      Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Vars.orchestrator_version] versions', versions)
      versions['orchestrator']
    end
  end
end
