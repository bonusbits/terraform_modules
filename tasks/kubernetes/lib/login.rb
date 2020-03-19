module Orchestrator
  module Kubernetes
    module Login
      def self.pod(namespace, pod)
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Kubernetes.login] namespace', namespace)
        command = <<-LOGIN
          pod_name=$(kubectl get pods --namespace #{namespace} | grep #{pod} | awk '{print $1}' | head -n 1)
          kubectl exec --namespace #{namespace} -it $pod_name -- /bin/sh
        LOGIN
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Kubernetes::Login.pod] command', command)
        system(command)
      end
    end
  end
end
