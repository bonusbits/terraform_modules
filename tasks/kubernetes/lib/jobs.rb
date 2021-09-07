module Orchestrator
  module Kubernetes
    module Jobs
      def self.describe_job(namespace, job_name)
        command = "kubectl describe job #{job_name} --namespace #{namespace}"
        output = Orchestrator::Shell.run_command_strout(command)
        Orchestrator::ConsoleOutputs.message(output)
      end

      def self.get_jobs(namespace, verbose = false)
        c1 = namespace == 'all' ? 'kubectl get jobs --all-namespaces' : "kubectl get jobs --namespace #{namespace}"
        c2 = verbose ? ' --show-labels -o wide' : ''
        command = c1 + c2
        output = Orchestrator::Shell.run_command_strout(command)
        Orchestrator::ConsoleOutputs.message(output)
      end
    end
  end
end
