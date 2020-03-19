module Orchestrator
  module Kubernetes
    module Config
      def self.show_clusters
        command = 'kubectl config get-clusters'
        output = Orchestrator::Shell.run_command_strout(command)
        Orchestrator::ConsoleOutputs.message(output)
      end

      def self.show_contexts
        command = 'kubectl config get-contexts'
        output = Orchestrator::Shell.run_command_strout(command)
        Orchestrator::ConsoleOutputs.message(output)
      end

      def self.view
        command = 'kubectl config view'
        output = Orchestrator::Shell.run_command_strout(command)
        Orchestrator::ConsoleOutputs.message(output)
      end

      def self.replace
        config_path = $project_vars['kubernetes']['config_path']
        Orchestrator::Shell.run_command_strout("rm -f #{config_path}") if File.exist?(config_path)
        command = "aws eks --region #{$project_vars['aws']['region']} --profile #{$project_vars['aws']['profile']} update-kubeconfig --name #{$project_vars['terraform']['workspace']} --alias #{$project_vars['terraform']['workspace']} --kubeconfig #{config_path}"
        output = Orchestrator::Shell.run_command_strout(command)
        Orchestrator::ConsoleOutputs.message(output)
      end

      def self.set_permissions
        config_path = $project_vars['kubernetes']['config_path']
        command = "chmod 0600 #{config_path}"
        output = Orchestrator::Shell.run_command_strout(command)
        Orchestrator::ConsoleOutputs.message(output)
      end

      def self.update
        config_path = $project_vars['kubernetes']['config_path']
        command = "aws eks --region #{$project_vars['aws']['region']} --profile #{$project_vars['aws']['profile']} update-kubeconfig --name #{$project_vars['terraform']['workspace']} --alias #{$project_vars['terraform']['workspace']} --kubeconfig #{config_path}"
        output = Orchestrator::Shell.run_command_strout(command)
        Orchestrator::ConsoleOutputs.message(output)
      end
    end
  end
end
