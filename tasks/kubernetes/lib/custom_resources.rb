module Orchestrator
  module Kubernetes
    module CustomResources
      def self.describe(name)
        command = "kubectl describe customresourcedefinitions #{name}"
        output = Orchestrator::Shell.run_command_strout(command)
        Orchestrator::ConsoleOutputs.message(output)
      end

      def self.get
        command = 'kubectl get customresourcedefinitions'
        output = Orchestrator::Shell.run_command_strout(command)
        Orchestrator::ConsoleOutputs.message(output)
      end
    end
  end
end
