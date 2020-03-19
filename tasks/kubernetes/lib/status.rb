module Orchestrator
  module Kubernetes
    module Status
      def self.pod_ready?(namespace)
        command = "kubectl -n #{namespace} get pods | tail -1 | awk {'print $3'}"
        output = Orchestrator::Shell.run_command_strout(command)
        Orchestrator::ConsoleOutputs.message(output)
      end

      def self.watch_pods(namespace)
        command = "kubectl get pods --namespace #{namespace} --watch"
        output = Orchestrator::Shell.run_command_strout(command)
        Orchestrator::ConsoleOutputs.message(output)
      end
    end
  end
end
