namespace :kubernetes do
  namespace :custom_resources do
    desc 'Kubernetes Describe a Custom Resource'
    task :describe, [:name] do |_task, args|
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header_item('Kubernetes Describe Custom Resource', args[:name])
      Orchestrator::Kubernetes::CustomResources.describe(args[:name])
    end

    desc 'Kubernetes Get Custom Resources'
    task :get do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header('Kubernetes Get Custom Resources')
      Orchestrator::Kubernetes::CustomResources.get
    end
  end
end

desc 'Alias (kubernetes:custom_resources:describe[name])'
task :k8s_desc_custom_resource, [:name] do |_task, args|
  Rake::Task['kubernetes:custom_resources:describe'].invoke(args[:name])
end

desc 'Alias (kubernetes:custom_resources:get[namespace])'
task k8s_get_custom_resources: %w[kubernetes:custom_resources:get]
