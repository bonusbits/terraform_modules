namespace :kubernetes do
  namespace :nodes do
    desc 'Kubernetes Describe a Node'
    task :describe_node, [:node_name] do |_task, args|
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header_item('Kubernetes Describe Node', "nodename=#{args[:node_name]}")
      Orchestrator::Kubernetes::Nodes.describe_node(args[:node_name])
    end

    desc 'Kubernetes Get Nodes'
    task :get_nodes, [:verbose] do |_task, args|
      Orchestrator::ConsoleOutputs.header
      verbose = args[:verbose] == 'verbose' || args[:verbose] == 'true'
      Orchestrator::ConsoleOutputs.sub_header_item('Kubernetes Get Nodes', "verbose=#{verbose}")
      Orchestrator::Kubernetes::Nodes.get_nodes(verbose)
    end

    desc 'Kubernetes Fetch Node IP'
    task :node_ip do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header('Kubernetes Fetch Node IP')
      result = Orchestrator::Kubernetes::Nodes.node_ip
      Orchestrator::ConsoleOutputs.message(result)
    end
  end
end

desc 'Alias (kubernetes:nodes:describe_node[node_name])'
task :k8s_desc_node, [:node_name] do |_task, args|
  Rake::Task['kubernetes:nodes:describe_node'].invoke(args[:node_name])
end

desc 'Alias (kubernetes:nodes:get_nodes[verbose])'
task :k8s_get_nodes, [:verbose] do |_task, args|
  Rake::Task['kubernetes:nodes:get_nodes'].invoke(args[:verbose])
end
