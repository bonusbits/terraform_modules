namespace :kubernetes do
  namespace :roles do
    desc 'Kubernetes Describe a Role'
    task :describe_role, [:namespace, :role_name] do |_task, args|
      Orchestrator::ConsoleOutputs.header
      namespace = args[:namespace]
      Orchestrator::ConsoleOutputs.sub_header_item('Kubernetes Describe Role', "namespace=#{namespace}, servicename=#{args[:role_name]}")
      Orchestrator::Kubernetes::Roles.describe_role(namespace, args[:role_name])
    end

    desc 'Kubernetes Get Roles'
    task :get_roles, [:namespace, :verbose] do |_task, args|
      Orchestrator::ConsoleOutputs.header
      namespace = args[:namespace].nil? ? 'all' : args[:namespace]
      verbose = args[:verbose] == 'verbose' || args[:verbose] == 'true'
      Orchestrator::ConsoleOutputs.sub_header_item('Kubernetes Get Roles', "namespace=#{namespace}, verbose=#{verbose}")
      Orchestrator::Kubernetes::Roles.get_roles(namespace, verbose)
    end
  end
end

desc 'Alias (kubernetes:roles:describe_role[namespace,role_name])'
task :k8s_desc_role, [:namespace, :role_name] do |_task, args|
  Rake::Task['kubernetes:roles:describe_role'].invoke(args[:namespace], args[:role_name])
end

desc 'Alias (kubernetes:roles:get_roles[namespace])'
task :k8s_get_roles, [:namespace, :verbose] do |_task, args|
  Rake::Task['kubernetes:roles:get_roles'].invoke(args[:namespace], args[:verbose])
end
