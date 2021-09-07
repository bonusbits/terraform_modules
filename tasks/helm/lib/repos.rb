module Orchestrator
  module Helm
    module Repos
      def self.add(name, url)
        command = "helm repo add #{name} #{url}"
        output = Orchestrator::Shell.run_command_strout(command)
        Orchestrator::ConsoleOutputs.message(output)
      end

      def self.list_charts(name = nil)
        command = "helm search repo #{name}"
        output = Orchestrator::Shell.run_command_strout(command)
        Orchestrator::ConsoleOutputs.message(output)
      end

      def self.remove(name)
        command = "helm repo remove #{name}"
        output = Orchestrator::Shell.run_command_strout(command)
        Orchestrator::ConsoleOutputs.message(output)
      end

      def self.update
        command = 'helm repo update'
        output = Orchestrator::Shell.run_command_strout(command)
        Orchestrator::ConsoleOutputs.message(output)
      end
    end
  end
end
