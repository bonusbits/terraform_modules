module Orchestrator
  module Packer
    module Vars
      def self.local_version
        Orchestrator::Shell.run_command_strout('packer -v | head -c -1').strip
      end

      def self.show_common_vars
        puts Orchestrator::Packer::Cli.load_command_vars
      end
    end
  end
end
