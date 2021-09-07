namespace :kubernetes do
  namespace :config_maps do
    desc 'Kubernetes Add AWS Auth IAM Users'
    task :add_aws_auth do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header('Kubernetes Add AWS Auth IAM Users')
      Orchestrator::Kubernetes::ConfigMaps.add_aws_auth
    end

    desc 'Kubernetes Display AWS Auth User Map'
    task :display_aws_auth_map_example do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header('Kubernetes Display AWS Auth User Map')
      Orchestrator::Kubernetes::ConfigMaps.display_aws_auth_map_example
    end

    desc 'Kubernetes Edit AWS Auth Config Map'
    task :edit_aws_auth do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header('Kubernetes Edit AWS Auth Config Map')
      Orchestrator::Kubernetes::ConfigMaps.edit_aws_auth
    end

    desc 'Kubernetes Describe a Config Map'
    task :describe_config_map, [:namespace, :name] do |_task, args|
      Orchestrator::ConsoleOutputs.header
      namespace = args[:namespace]
      Orchestrator::ConsoleOutputs.sub_header_item('Kubernetes Describe Config Map', "namespace=#{namespace}, configmap=#{args[:name]}")
      Orchestrator::Kubernetes::ConfigMaps.describe_config_map(namespace, args[:name])
    end

    desc 'Kubernetes Get Config Maps'
    task :get_config_maps, [:namespace, :verbose] do |_task, args|
      Orchestrator::ConsoleOutputs.header
      namespace = args[:namespace].nil? ? 'all' : args[:namespace]
      verbose = args[:verbose] == 'verbose' || args[:verbose] == 'true'
      Orchestrator::ConsoleOutputs.sub_header_item('Kubernetes Get Config Maps', "namespace=#{namespace}, verbose=#{verbose}")
      Orchestrator::Kubernetes::ConfigMaps.get_config_maps(namespace, verbose)
    end
  end
end

desc 'Alias (kubernetes:config_maps:describe_config_map[namespace,role_name])'
task :k8s_desc_configmap, [:namespace, :name] do |_task, args|
  Rake::Task['kubernetes:config_maps:describe_config_map'].invoke(args[:namespace], args[:name])
end

desc 'Alias (kubernetes:config_maps:get_config_maps[namespace])'
task :k8s_get_configmaps, [:namespace, :verbose] do |_task, args|
  Rake::Task['kubernetes:config_maps:get_config_maps'].invoke(args[:namespace], args[:verbose])
end

desc 'Alias (kubernetes:config_maps:describe_config_map[kube-system,aws-auth])'
task :k8s_desc_configmap_awsauth do
  Rake::Task['kubernetes:config_maps:describe_config_map'].invoke('kube-system', 'aws-auth')
end

desc 'Alias (kubernetes:config_maps:edit_aws_auth)'
task k8s_edit_configmap_awsauth: ['kubernetes:config_maps:edit_aws_auth']
