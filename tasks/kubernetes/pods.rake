namespace :kubernetes do
  namespace :pods do
    desc 'Kubernetes Describe a Pod'
    task :describe_pod, [:namespace, :pod_name] do |_task, args|
      Orchestrator::ConsoleOutputs.header
      namespace = args[:namespace]
      Orchestrator::ConsoleOutputs.sub_header_item('Kubernetes Describe Pod', "namespace=#{namespace}, podname=#{args[:pod_name]}")
      Orchestrator::Kubernetes::Pods.describe_pod(namespace, args[:pod_name])
    end

    desc 'Kubernetes Get Pods'
    task :get_pods, [:namespace, :verbose] do |_task, args|
      Orchestrator::ConsoleOutputs.header
      namespace = args[:namespace].nil? ? 'all' : args[:namespace]
      verbose = args[:verbose] == 'verbose' || args[:verbose] == 'true'
      Orchestrator::ConsoleOutputs.sub_header_item('Kubernetes Get Pods', "namespace=#{namespace}, verbose=#{verbose}")
      Orchestrator::Kubernetes::Pods.get_pods(namespace, verbose)
    end

    desc 'Kubernetes Status of a Pod Loop'
    task :status_loop, [:namespace, :pod_name] do |_task, args|
      Orchestrator::ConsoleOutputs.header
      namespace = args[:namespace]
      Orchestrator::ConsoleOutputs.sub_header_item('Kubernetes Status of a Pod Loop', "namespace=#{namespace}, podname=#{args[:pod_name]}")
      Orchestrator::Kubernetes::Pods.status_loop(namespace, args[:pod_name])
    end

    desc 'Kubernetes Status of a Pod'
    task :status_pod, [:namespace, :pod_name] do |_task, args|
      Orchestrator::ConsoleOutputs.header
      namespace = args[:namespace]
      Orchestrator::ConsoleOutputs.sub_header_item('Kubernetes Status of a Pod', "namespace=#{namespace}, podname=#{args[:pod_name]}")
      results = Orchestrator::Kubernetes::Pods.status_pod(namespace, args[:pod_name])
      Orchestrator::ConsoleOutputs.message(results)
    end
  end
end

desc 'Alias (kubernetes:pods:describe_pod[namespace,pod_name])'
task :k8s_desc_pod, [:namespace, :pod_name] do |_task, args|
  Rake::Task['kubernetes:pods:describe_pod'].invoke(args[:namespace], args[:pod_name])
end

desc 'Alias (kubernetes:pods:get_pods[namespace])'
task :k8s_get_pods, [:namespace, :verbose] do |_task, args|
  Rake::Task['kubernetes:pods:get_pods'].invoke(args[:namespace], args[:verbose])
end

desc 'Alias (kubernetes:pods:status_loop[namespace,pod_name])'
task :k8s_status_loop, [:namespace, :pod_name] do |_task, args|
  Rake::Task['kubernetes:pods:status_loop'].invoke(args[:namespace], args[:pod_name])
end

desc 'Alias (kubernetes:pods:status_pod[namespace,pod_name])'
task :k8s_status_pod, [:namespace, :pod_name] do |_task, args|
  Rake::Task['kubernetes:pods:status_pod'].invoke(args[:namespace], args[:pod_name])
end
