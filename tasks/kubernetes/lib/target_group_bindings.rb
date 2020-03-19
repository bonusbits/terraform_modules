module Orchestrator
  module Kubernetes
    module TargetGroupBindings
      def self.describe(namespace, name)
        command = "kubectl describe targetgroupbindings #{name} --namespace #{namespace}"
        output = Orchestrator::Shell.run_command_strout(command)
        Orchestrator::ConsoleOutputs.message(output)
      end

      def self.get(namespace, verbose = false)
        c1 = namespace == 'all' ? 'kubectl get targetgroupbindings --all-namespaces' : "kubectl get targetgroupbindings --namespace #{namespace}"
        c2 = verbose ? ' --show-labels -o wide' : ''
        command = c1 + c2
        output = Orchestrator::Shell.run_command_strout(command)
        Orchestrator::ConsoleOutputs.message(output)
      end
    end
  end
end
