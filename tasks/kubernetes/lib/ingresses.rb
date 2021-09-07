module Orchestrator
  module Kubernetes
    module Ingress
      def self.describe_ingress(namespace, ingress_name)
        command = "kubectl describe ingress #{ingress_name} --namespace #{namespace}"
        output = Orchestrator::Shell.run_command_strout(command)
        Orchestrator::ConsoleOutputs.message(output)
      end

      def self.get_ingresses(namespace, verbose = false)
        c1 = namespace == 'all' ? 'kubectl get ingress --all-namespaces' : "kubectl get ingress --namespace #{namespace}"
        c2 = verbose ? ' --show-labels -o wide' : ''
        command = c1 + c2
        output = Orchestrator::Shell.run_command_strout(command)
        Orchestrator::ConsoleOutputs.message(output)
      end
    end
  end
end
