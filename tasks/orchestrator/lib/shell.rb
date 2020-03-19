module Orchestrator
  module Shell
    def self.clear_screen
      if RUBY_PLATFORM =~ /win32|win64|\.NET|windows|cygwin|mingw32/i
        system('cls')
      else
        system('clear')
      end
    end

    def self.run_command(command)
      # Will not show output until completed which sucks if want to watch the progress.
      require 'open3'
      out, err, status = Open3.capture3(command)

      successful = status.success?
      Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Shell.run_command] Shell Command', command)
      Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Shell.run_command] Status', status)
      Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Shell.run_command] Standard Out', out)
      Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Shell.run_command] Successful?', successful)
      unless successful
        Orchestrator::ConsoleOutputs.error_message('[Orchestrator::Shell.run_command] Unsuccessful Command!')
        Orchestrator::ConsoleOutputs.error_message_item('[Orchestrator::Shell.run_command] Error Out', err)
      end
      successful
    end

    def self.run_command_strout(command)
      # Will not show output until completed which sucks if want to watch the progress.
      require 'open3'
      # out, err, status = Open3.capture3("/bin/bash -c \"#{shell_command}\"")
      out, err, status = Open3.capture3(command)
      successful = status.success?
      Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Shell.run_command_strout] Shell Command', command)
      Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Shell.run_command_strout] Status', status)
      # Orchestrator::ConsoleOutputs.debug_message_item('Standard Out', out)
      Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Shell.run_command_strout] Successful?', successful)
      unless successful
        Orchestrator::ConsoleOutputs.error_message('[Orchestrator::Shell.run_command_strout] Unsuccessful Command!')
        Orchestrator::ConsoleOutputs.error_message_item('[Orchestrator::Shell.run_command_strout] Error Out', err)
      end
      out
    end
  end
end
