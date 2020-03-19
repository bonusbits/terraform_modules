namespace :kubernetes do
  namespace :target_group_bindings do
    desc 'Kubernetes Describe a Target Group Binding'
    task :describe, [:namespace, :name] do |_task, args|
      Orchestrator::ConsoleOutputs.header
      namespace = args[:namespace]
      Orchestrator::ConsoleOutputs.sub_header_item('Kubernetes Describe Target Group Binding', "namespace=#{namespace}, servicename=#{args[:name]}")
      Orchestrator::Kubernetes::TargetGroupBindings.describe(namespace, args[:name])
    end

    desc 'Kubernetes Get Target Group Bindings'
    task :get, [:namespace, :verbose] do |_task, args|
      Orchestrator::ConsoleOutputs.header
      namespace = args[:namespace].nil? ? 'all' : args[:namespace]
      verbose = args[:verbose] == 'verbose' || args[:verbose] == 'true'
      Orchestrator::ConsoleOutputs.sub_header_item('Kubernetes Get Target Group Bindings', "namespace=#{namespace}, verbose=#{verbose}")
      Orchestrator::Kubernetes::TargetGroupBindings.get(namespace, verbose)
    end
  end
end

desc 'Alias (kubernetes:target_group_bindings:describe[namespace,service_name])'
task :k8s_desc_target_group_binding, [:namespace, :name] do |_task, args|
  Rake::Task['kubernetes:target_group_bindings:describe'].invoke(args[:namespace], args[:name])
end

desc 'Alias (kubernetes:target_group_bindings:get[namespace,verbose])'
task :k8s_get_target_group_bindings, [:namespace, :verbose] do |_task, args|
  Rake::Task['kubernetes:target_group_bindings:get'].invoke(args[:namespace], args[:verbose])
end
