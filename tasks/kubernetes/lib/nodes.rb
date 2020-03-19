module Orchestrator
  module Kubernetes
    module Nodes
      def self.describe_node(node_name)
        command = "kubectl describe node #{node_name}"
        output = Orchestrator::Shell.run_command_strout(command)
        Orchestrator::ConsoleOutputs.message(output)
      end

      def self.node_ip
        command = 'kubectl get nodes -o wide | grep ^ip- | head -1 | awk {\'print $6\'}'
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Kubernetes::Nodes.node_ip] command', command)
        node_ip = Orchestrator::Shell.run_command_strout(command).strip
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Kubernetes::Nodes.node_ip] node_ip', node_ip)
        node_ip
      end

      def self.get_nodes(verbose = false)
        c1 = 'kubectl get nodes'
        c2 = verbose ? ' --show-labels -o wide' : ''
        command = c1 + c2
        output = Orchestrator::Shell.run_command_strout(command)
        Orchestrator::ConsoleOutputs.message(output)
      end
    end
  end
end
