namespace :kubernetes do
  namespace :service_accounts do
    desc 'Kubernetes Describe a Service Account'
    task :describe, [:namespace, :service_name] do |_task, args|
      Orchestrator::ConsoleOutputs.header
      namespace = args[:namespace]
      Orchestrator::ConsoleOutputs.sub_header_item('Kubernetes Describe Service Account', "namespace=#{namespace}, servicename=#{args[:service_name]}")
      Orchestrator::Kubernetes::ServiceAccounts.describe(namespace, args[:service_name])
    end

    desc 'Kubernetes Get Service Accounts'
    task :get, [:namespace, :verbose] do |_task, args|
      Orchestrator::ConsoleOutputs.header
      namespace = args[:namespace].nil? ? 'all' : args[:namespace]
      verbose = args[:verbose] == 'verbose' || args[:verbose] == 'true'
      Orchestrator::ConsoleOutputs.sub_header_item('Kubernetes Get Service Accounts', "namespace=#{namespace}, verbose=#{verbose}")
      Orchestrator::Kubernetes::ServiceAccounts.get(namespace, verbose)
    end
  end
end

desc 'Alias (kubernetes:service_accounts:describe[namespace,service_name])'
task :k8s_desc_service_account, [:namespace, :service_name] do |_task, args|
  Rake::Task['kubernetes:service_accounts:describe'].invoke(args[:namespace], args[:service_name])
end

desc 'Alias (kubernetes:service_accounts:get[namespace])'
task :k8s_get_service_accounts, [:namespace, :verbose] do |_task, args|
  Rake::Task['kubernetes:service_accounts:get'].invoke(args[:namespace], args[:verbose])
end
