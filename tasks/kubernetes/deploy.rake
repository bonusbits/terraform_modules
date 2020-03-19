namespace :kubernetes do
  namespace :deploy do
    # TODO: WIP
    desc 'Kubernetes Check Deployment'
    task :check_deployment, [:namespace, :pod_name] do |_task, args|
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header_item('Kubernetes Check Deployment', "#{args[:namespace]}/#{args[:pod_name]}")
      Orchestrator::Kubernetes::Deploy.check_deployment(args[:namespace], args[:pod_name])
    end
  end
end
