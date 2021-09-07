module Orchestrator
  module Kubernetes
    module Deploy
      # TODO: WIP
      def self.check_deployment(namespace, pod_name)
        command = <<-CHECKDEPLOYMENT
        @count=0;
          until [ $(kubectl get deployments --namespace #{namespace} | grep #{pod_name} | awk '{print $4}' | tr -d '\n') == '1' ] || [ $count -lt 60 ];
          do
            let count+=1;
            echo "INFO: Deployment NOT Running (Count: $count)";
            sleep 5;
          done
          @if [ $(kubectl get deployments --namespace #{namespace} | grep #{pod_name} | awk '{print $4}' | tr -d '\n') == '1' ]; then echo 'INFO: Deployment Success!'; else echo 'ERROR: Deployment Failure'; fi
        CHECKDEPLOYMENT

        output = Orchestrator::Shell.run_command_strout(command)
        Orchestrator::ConsoleOutputs.message(output)
      end

      def self.deployment(namespace, service)
        command = "kubectl apply -f #{$project_vars['orchestrator']['orchestrator_path']}/kubernetes/#{$project_vars['terraform']['workspace']}/#{service}/deployment.yml --namespace=#{namespace}"
        output = Orchestrator::Shell.run_command_strout(command)
        Orchestrator::ConsoleOutputs.message(output)
      end

      def self.service(namespace, service)
        command = "kubectl apply -f #{$project_vars['orchestrator']['orchestrator_path']}/kubernetes/#{$project_vars['terraform']['workspace']}/#{service}/service.yml --namespace=#{namespace}"
        output = Orchestrator::Shell.run_command_strout(command)
        Orchestrator::ConsoleOutputs.message(output)
      end
    end
  end
end
