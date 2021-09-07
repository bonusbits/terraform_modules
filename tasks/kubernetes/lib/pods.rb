module Orchestrator
  module Kubernetes
    module Pods
      def self.describe_pod(namespace, pod_name)
        command = "kubectl describe pod #{pod_name} --namespace #{namespace}"
        output = Orchestrator::Shell.run_command_strout(command)
        Orchestrator::ConsoleOutputs.message(output)
      end

      def self.get_pods(namespace, verbose = false)
        c1 = namespace == 'all' ? 'kubectl get pods --all-namespaces' : "kubectl get pods --namespace #{namespace}"
        c2 = verbose ? ' --show-labels -o wide' : ''
        command = c1 + c2
        output = Orchestrator::Shell.run_command_strout(command)
        Orchestrator::ConsoleOutputs.message(output)
      end

      def self.status_loop(namespace, pod_name)
        loop_count = 0
        pod_status = 'Unknown'
        Orchestrator::ConsoleOutputs.message('Checking Pod Status')
        until loop_count >= 180 || pod_status == 'Running'
          loop_count += 1
          print '.'
          pod_status = Orchestrator::Kubernetes::Pods.status_pod(namespace, pod_name).strip
          sleep 5 unless pod_status == 'Running'
        end
        pod_status == 'Running' ? Orchestrator::ConsoleOutputs.message('Running') : Orchestrator::ConsoleOutputs.error_message(pod_status)
      end

      def self.status_pod(namespace, pod_name)
        command = "kubectl get pods #{pod_name} --namespace #{namespace} --no-headers -o custom-columns=\":status.phase\""
        Orchestrator::Shell.run_command_strout(command)
      end
    end
  end
end
