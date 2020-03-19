module Orchestrator
  module Kubernetes
    module Services
      def self.describe_service(namespace, service_name)
        command = "kubectl describe service #{service_name} --namespace #{namespace}"
        output = Orchestrator::Shell.run_command_strout(command)
        Orchestrator::ConsoleOutputs.message(output)
      end

      def self.get_services(namespace, verbose = false)
        c1 = namespace == 'all' ? 'kubectl get service --all-namespaces' : "kubectl get service --namespace #{namespace}"
        c2 = verbose ? ' --show-labels -o wide' : ''
        command = c1 + c2
        output = Orchestrator::Shell.run_command_strout(command)
        Orchestrator::ConsoleOutputs.message(output)
      end
    end
  end
end
