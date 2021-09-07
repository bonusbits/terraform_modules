module Orchestrator
  module Kubernetes
    module ServiceAccounts
      def self.describe(namespace, service_account_name)
        command = "kubectl describe serviceaccount #{service_account_name} --namespace #{namespace}"
        output = Orchestrator::Shell.run_command_strout(command)
        Orchestrator::ConsoleOutputs.message(output)
      end

      def self.get(namespace, verbose = false)
        c1 = namespace == 'all' ? 'kubectl get serviceaccounts --all-namespaces' : "kubectl get serviceaccounts --namespace #{namespace}"
        c2 = verbose ? ' --show-labels -o wide' : ''
        command = c1 + c2
        output = Orchestrator::Shell.run_command_strout(command)
        Orchestrator::ConsoleOutputs.message(output)
      end
    end
  end
end
