namespace :kubernetes do
  namespace :deployments do
    desc 'Kubernetes Describe a Deployment'
    task :describe_deployment, [:namespace, :deployment_name] do |_task, args|
      Orchestrator::ConsoleOutputs.header
      namespace = args[:namespace]
      Orchestrator::ConsoleOutputs.sub_header_item('Kubernetes Describe Deployment', "namespace=#{namespace}, servicename=#{args[:deployment_name]}")
      Orchestrator::Kubernetes::Deployments.describe_deployment(namespace, args[:deployment_name])
    end

    desc 'Kubernetes Get Deployments'
    task :get_deployments, [:namespace, :verbose] do |_task, args|
      Orchestrator::ConsoleOutputs.header
      namespace = args[:namespace].nil? ? 'all' : args[:namespace]
      verbose = args[:verbose] == 'verbose' || args[:verbose] == 'true'
      Orchestrator::ConsoleOutputs.sub_header_item('Kubernetes Get Deployments', "namespace=#{namespace}, verbose=#{verbose}")
      Orchestrator::Kubernetes::Deployments.get_deployment(namespace, verbose)
    end
  end
end

desc 'Alias (kubernetes:deployments:describe_deployment[namespace,deployment_name])'
task :k8s_desc_deployment, [:namespace, :deployment_name] do |_task, args|
  Rake::Task['kubernetes:deployments:describe_deployment'].invoke(args[:namespace], args[:deployment_name])
end

desc 'Alias (kubernetes:deployments:get_services[namespace])'
task :k8s_get_deployments, [:namespace, :verbose] do |_task, args|
  Rake::Task['kubernetes:deployments:get_deployments'].invoke(args[:namespace], args[:verbose])
end
