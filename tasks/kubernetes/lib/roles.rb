module Orchestrator
  module Kubernetes
    module Roles
      def self.describe_role(namespace, service_account_name)
        command = "kubectl describe role #{service_account_name} --namespace #{namespace}"
        output = Orchestrator::Shell.run_command_strout(command)
        Orchestrator::ConsoleOutputs.message(output)
      end

      def self.get_roles(namespace, verbose = false)
        c1 = namespace == 'all' ? 'kubectl get roles --all-namespaces' : "kubectl get roles --namespace #{namespace}"
        c2 = verbose ? ' --show-labels -o wide' : ''
        command = c1 + c2
        output = Orchestrator::Shell.run_command_strout(command)
        Orchestrator::ConsoleOutputs.message(output)
      end
    end
  end
end
