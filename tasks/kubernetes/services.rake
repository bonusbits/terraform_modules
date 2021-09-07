namespace :kubernetes do
  namespace :services do
    desc 'Kubernetes Describe a Service'
    task :describe_service, [:namespace, :service_name] do |_task, args|
      Orchestrator::ConsoleOutputs.header
      namespace = args[:namespace]
      Orchestrator::ConsoleOutputs.sub_header_item('Kubernetes Describe Service', "namespace=#{namespace}, servicename=#{args[:service_name]}")
      Orchestrator::Kubernetes::Services.describe_service(namespace, args[:service_name])
    end

    desc 'Kubernetes Get Services'
    task :get_services, [:namespace, :verbose] do |_task, args|
      Orchestrator::ConsoleOutputs.header
      namespace = args[:namespace].nil? ? 'all' : args[:namespace]
      verbose = args[:verbose] == 'verbose' || args[:verbose] == 'true'
      Orchestrator::ConsoleOutputs.sub_header_item('Kubernetes Get Services', "namespace=#{namespace}, verbose=#{verbose}")
      Orchestrator::Kubernetes::Services.get_services(namespace, verbose)
    end
  end
end

desc 'Alias (kubernetes:services:describe_service[namespace,service_name])'
task :k8s_desc_service, [:namespace, :service_name] do |_task, args|
  Rake::Task['kubernetes:services:describe_service'].invoke(args[:namespace], args[:service_name])
end

desc 'Alias (kubernetes:services:get_services[namespace])'
task :k8s_get_services, [:namespace, :verbose] do |_task, args|
  Rake::Task['kubernetes:services:get_services'].invoke(args[:namespace], args[:verbose])
end
