module Orchestrator
  module Kubernetes
    module Namespaces
      def self.describe(name)
        command = "kubectl describe namespaces #{name}"
        output = Orchestrator::Shell.run_command_strout(command)
        Orchestrator::ConsoleOutputs.message(output)
      end

      def self.get
        command = 'kubectl get namespaces --show-labels'
        output = Orchestrator::Shell.run_command_strout(command)
        Orchestrator::ConsoleOutputs.message(output)
      end

      def self.create_namespace(namespace)
        command = "kubectl get namespaces | grep -w #{namespace} || kubectl create namespace #{namespace}"
        output = Orchestrator::Shell.run_command_strout(command)
        Orchestrator::ConsoleOutputs.message(output)
      end
    end
  end
end
