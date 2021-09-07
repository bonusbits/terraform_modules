module Orchestrator
  module Kubernetes
    module Deployments
      def self.describe_deployment(namespace, deployment_name)
        command = "kubectl describe deployment #{deployment_name} --namespace #{namespace}"
        output = Orchestrator::Shell.run_command_strout(command)
        Orchestrator::ConsoleOutputs.message(output)
      end

      def self.get_deployment(namespace, verbose = false)
        c1 = namespace == 'all' ? 'kubectl get deployment --all-namespaces' : "kubectl get deployment --namespace #{namespace}"
        c2 = verbose ? ' --show-labels -o wide' : ''
        command = c1 + c2
        output = Orchestrator::Shell.run_command_strout(command)
        Orchestrator::ConsoleOutputs.message(output)
      end
    end
  end
end
