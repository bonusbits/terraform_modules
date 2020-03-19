namespace :kubernetes do
  namespace :logs do
    desc 'Kubernetes Deployment Logs'
    task :deployment, [:namespace, :deployment_name, :follow] do |_task, args|
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header_item('Kubernetes Logs', "namespace=#{args[:namespace]}, deployment=#{args[:deployment_name]}")
      Orchestrator::Kubernetes::Logs.deployment(args[:namespace], args[:deployment_name], args[:follow])
    end
  end
end

desc 'Alias (kubernetes:logs:deployment[cert-manager,deployment.app/cert-manager])'
task :k8s_logs_cert_manager do
  Rake::Task['kubernetes:logs:deployment'].invoke('cert-manager', 'deployment.app/cert-manager')
end

desc 'Alias (kubernetes:logs:deployment[cert-manager,deployment.app/cert-manager])'
task :k8s_logs_cert_manager_f do
  Rake::Task['kubernetes:logs:deployment'].invoke('cert-manager', 'deployment.app/cert-manager', true)
end

desc 'Alias (kubernetes:logs:deployment[kube-system,deployment.apps/aws-load-balancer-controller])'
task :k8s_logs_ingress_controller do
  Rake::Task['kubernetes:logs:deployment'].invoke('kube-system', 'deployment.apps/aws-load-balancer-controller')
end

desc 'Alias (kubernetes:logs:deployment[kube-system,deployment.apps/aws-load-balancer-controller])'
task :k8s_logs_ingress_controller_f do
  Rake::Task['kubernetes:logs:deployment'].invoke('kube-system', 'deployment.apps/aws-load-balancer-controller', true)
end

desc 'Alias (kubernetes:logs:deployment[namespace,deployment_name])'
task :k8s_logs, [:namespace, :deployment_name, :follow] do |_task, args|
  Rake::Task['kubernetes:logs:deployment'].invoke(args[:namespace], args[:deployment_name], args[:follow])
end
