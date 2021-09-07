namespace :kubernetes do
  namespace :namespaces do
    desc 'Kubernetes Describe Namespace'
    task :describe, [:name] do |_task, args|
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header_item('Kubernetes Describe Namespace', args[:name])
      Orchestrator::Kubernetes::Namespaces.describe(args[:name])
    end

    desc 'Kubernetes Namespaces'
    task :get do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header('Kubernetes Namespaces')
      Orchestrator::Kubernetes::Namespaces.get
    end
  end
end

desc 'Alias (kubernetes:namespaces:describe[name])'
task :k8s_desc_namespace, [:name] do |_task, args|
  Rake::Task['kubernetes:namespaces:describe'].invoke(args[:name])
end

desc 'Alias (kubernetes:namespaces:get)'
task k8s_get_namespaces: %w[kubernetes:namespaces:get]
