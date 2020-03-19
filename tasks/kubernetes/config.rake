namespace :kubernetes do
  namespace :config do
    desc 'Display Kubectl Config Clusters (Local)'
    task :get_clusters do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header('Kubectl Config Clusters (Local)')
      Orchestrator::Kubernetes::Config.show_clusters
    end

    desc 'Display Kubectl Config Contexts (Local)'
    task :get_contexts do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header('Kubectl Config Contexts (Local)')
      Orchestrator::Kubernetes::Config.show_contexts
    end

    desc 'Display Kubectl Config'
    task :view do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header('Display Kubectl Config')
      Orchestrator::Kubernetes::Config.view
    end

    desc 'Replace Kubectl Config'
    task :replace do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header('Replace Kubectl Config')
      Orchestrator::Kubernetes::Config.replace
      Orchestrator::Kubernetes::Config.set_permissions
    end

    desc 'Update Kubectl Config (Append)'
    task :update do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header('Update Kubectl Config (Append)')
      Orchestrator::Kubernetes::Config.update
      Orchestrator::Kubernetes::Config.set_permissions
    end
  end
end

desc 'Alias (kubernetes:config:get_contexts)'
task kube_config_contexts: %w[kubernetes:config:get_contexts]
