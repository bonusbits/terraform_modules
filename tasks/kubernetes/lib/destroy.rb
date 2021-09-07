module Orchestrator
  module Kubernetes
    module Destroy
      def self.namespace(namespace)
        command = "kubectl get namespaces #{namespace} || kubectl delete namespaces #{namespace}"
        output = Orchestrator::Shell.run_command_strout(command)
        Orchestrator::ConsoleOutputs.message(output)
      end

      def self.deployment(namespace, service)
        command = "kubectl delete -f #{$project_vars['orchestrator']['orchestrator_path']}/kubernetes/#{$project_vars['terraform']['workspace']}/#{service}/deployment.yml --namespace=#{namespace}"
        output = Orchestrator::Shell.run_command_strout(command)
        Orchestrator::ConsoleOutputs.message(output)
      end

      def self.service(namespace, service)
        command = "kubectl delete -f #{$project_vars['orchestrator']['orchestrator_path']}/kubernetes/#{$project_vars['terraform']['workspace']}/#{service}/service.yml --namespace=#{namespace}"
        output = Orchestrator::Shell.run_command_strout(command)
        Orchestrator::ConsoleOutputs.message(output)
      end
    end
  end
end
