module Orchestrator
  module Kubernetes
    module Logs
      def self.deployment(namespace, deployment_name, follow = false)
        command = follow ? "kubectl logs -f --namespace #{namespace} #{deployment_name}" : "kubectl logs --namespace #{namespace} #{deployment_name}"
        system(command)
      end

      def self.pod(namespace, name, follow = false)
        command = follow ? "kubectl logs -f --namespace #{namespace} #{name}" : "kubectl logs --namespace #{namespace} #{name}"
        system(command)
      end
    end
  end
end
