namespace :kubernetes do
  namespace :ingress do
    desc 'Kubernetes Describe an Ingress'
    task :describe_ingress, [:namespace, :ingress_name] do |_task, args|
      Orchestrator::ConsoleOutputs.header
      namespace = args[:namespace]
      Orchestrator::ConsoleOutputs.sub_header_item('Kubernetes Describe an Ingress', "namespace=#{namespace}, ingressname=#{args[:ingress_name]}")
      Orchestrator::Kubernetes::Ingress.describe_ingress(namespace, args[:ingress_name])
    end

    desc 'Kubernetes Get Ingress'
    task :get_ingresses, [:namespace, :verbose] do |_task, args|
      Orchestrator::ConsoleOutputs.header
      namespace = args[:namespace].nil? ? 'all' : args[:namespace]
      verbose = args[:verbose] == 'verbose' || args[:verbose] == 'true'
      Orchestrator::ConsoleOutputs.sub_header_item('Kubernetes Get Ingress', "namespace=#{namespace}, verbose=#{verbose}")
      Orchestrator::Kubernetes::Ingress.get_ingresses(namespace, verbose)
    end
  end
end

desc 'Alias (kubernetes:ingress:describe_ingress[namespace,ingress_name])'
task :k8s_desc_ingress, [:namespace, :ingress_name] do |_task, args|
  Rake::Task['kubernetes:ingress:describe_ingress'].invoke(args[:namespace], args[:ingress_name])
end

desc 'Alias (kubernetes:ingress:get_ingresses[namespace])'
task :k8s_get_ingresses, [:namespace, :verbose] do |_task, args|
  Rake::Task['kubernetes:ingress:get_ingresses'].invoke(args[:namespace], args[:verbose])
end
