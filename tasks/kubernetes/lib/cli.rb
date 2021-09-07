module Orchestrator
  module Kubernetes
    module Cli
      # TODO: WIP to DRY up code
      def self.kubectl(command, sub_header, namespace, _verbose = false)
        Orchestrator::ConsoleOutputs.header
        Orchestrator::ConsoleOutputs.sub_header_item(sub_header, "#{image}/#{role}")

        system("kubectl #{command} --namespace #{namespace}")
      end
    end
  end
end
