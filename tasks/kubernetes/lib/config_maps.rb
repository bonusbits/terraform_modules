module Orchestrator
  module Kubernetes
    module ConfigMaps
      def self.add_aws_auth
        auth_added = Orchestrator::Kubernetes::ConfigMaps.auth_added?
        if auth_added
          Orchestrator::ConsoleOutputs.message('AWS Auth Already Added')
        else
          Orchestrator::Kubernetes::ConfigMaps.display_aws_auth_map_example
          Orchestrator::ConsoleOutputs.press_any_key
          Orchestrator::Kubernetes::ConfigMaps.edit_aws_auth
        end
      end

      def self.auth_added?
        command = 'kubectl describe configmap aws-auth --namespace kube-system'
        output = Orchestrator::Shell.run_command_strout(command)
        output.include?('user/devops.automation')
      end

      def self.edit_aws_auth
        command = 'kubectl edit -n kube-system configmap/aws-auth'
        system(command)
      end

      def self.display_aws_auth_map_example
        users_map = <<-USERMAP

  mapUsers: |
    - username: <first.last>
      userarn: arn:aws:iam::<***********>:user/<username>
      groups:
        - system:masters

        USERMAP
        Orchestrator::ConsoleOutputs.message(users_map)
        Orchestrator::ConsoleOutputs.message('^^^^^^^^^^^^^^^^^^ COPY ^^^^^^^^^^^^^^^^^^')
      end

      def self.get_config_maps(namespace, verbose = false)
        c1 = namespace == 'all' ? 'kubectl get configmap --all-namespaces' : "kubectl get configmap --namespace #{namespace}"
        c2 = verbose ? ' --show-labels -o wide' : ''
        command = c1 + c2
        output = Orchestrator::Shell.run_command_strout(command)
        Orchestrator::ConsoleOutputs.message(output)
      end

      def self.describe_config_map(namespace, name)
        command = "kubectl describe configmap #{name} --namespace #{namespace}"
        output = Orchestrator::Shell.run_command_strout(command)
        Orchestrator::ConsoleOutputs.message(output)
      end
    end
  end
end
