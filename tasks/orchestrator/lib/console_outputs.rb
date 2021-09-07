module Orchestrator
  module ConsoleOutputs
    def self.environment
      Orchestrator::ConsoleOutputs.header(true)
    end

    def self.debug_message(message)
      return unless $debug

      puts "DEBUG: #{message.to_s.colorize(:light_green)}"
    end

    def self.debug_message_item(message, item)
      return unless $debug

      puts "DEBUG: #{"#{message} (".colorize(:light_green)}#{item.to_s.colorize(:cyan)}#{')'.colorize(:light_green)}"
    end

    def self.error_message(message)
      puts "ERROR: #{message}".colorize(:light_red)
    end

    def self.error_message_item(message, item)
      puts "ERROR: #{message} (".colorize(:light_red) + item.to_s.colorize(:red) + ')'.colorize(:light_red)
    end

    def self.exclamation_sub_header(message)
      puts ''
      puts '*************************************************************************'.colorize(:light_green)
      puts '* '.colorize(:light_green) + message.to_s.colorize(:light_red)
      puts '*************************************************************************'.colorize(:light_green)
    end

    def self.footer(run_time)
      puts '------------------------------------------------------------------------'.colorize(:light_green)
      puts 'Workspace     ('.colorize(:light_green) + ($project_vars['terraform']['workspace']).to_s.colorize(:cyan) + ')'.colorize(:light_green)
      puts 'AWS Region    ('.colorize(:light_green) + ($project_vars['aws']['region']).to_s.colorize(:cyan) + ')'.colorize(:light_green)
      puts 'Run Time:     ('.colorize(:light_green) + run_time.to_s.colorize(:cyan) + ')'.colorize(:light_green)
    end

    # Display Ansi Logo
    def self.display_ansi_logo
      ansi_logo = Orchestrator::Logo.ansi
      print ansi_logo.colorize(:cyan)
    end

    def self.header(force = false)
      return unless $header_count.zero? || force

      Orchestrator::ConsoleOutputs.display_ansi_logo

      puts "BonusBits Orchestrator - v#{Orchestrator::Vars.orchestrator_version}".colorize(:light_green)
      puts '------------------------------------------------------------------------'.colorize(:light_green)
      Orchestrator::ConsoleOutputs.message_item('Environment ', $project_vars['orchestrator']['environment'])
      Orchestrator::ConsoleOutputs.message_item('Profile     ', $project_vars['aws']['profile'])
      Orchestrator::ConsoleOutputs.message_item('Region      ', $project_vars['aws']['region'])
      Orchestrator::ConsoleOutputs.message_item('Roles       ', $project_vars['terraform']['roles'])
      Orchestrator::ConsoleOutputs.message_item('Workspace   ', $project_vars['terraform']['workspace'])
      $header_count = 1
    end

    def self.highline_prompt_yellow(message)
      require 'highline'
      HighLine.agree("#{message}? (#{'y/n'.colorize(:light_yellow)}) ")
    end

    def self.highline_prompt_cyan(message)
      require 'highline'
      HighLine.agree("#{message}? (#{'y/n'.colorize(:cyan)}) ")
    end

    def self.highline_prompt_red(message)
      require 'highline'
      HighLine.agree("#{message}? (#{'y/n'.colorize(:light_red)}) ")
    end

    def self.info_message(message)
      # require 'colorize'
      puts "INFO: #{message.to_s.colorize(:light_green)}"
    end

    def self.info_message_item(message, item)
      puts "INFO: #{"#{message} (".colorize(:light_green)}#{item.to_s.colorize(:cyan)}#{')'.colorize(:light_green)}"
    end

    def self.message(message)
      puts message.colorize(:cyan)
    end

    def self.message_item(message, item)
      puts "#{message} (".colorize(:light_green) + item.to_s.colorize(:cyan) + ')'.colorize(:light_green)
    end

    def self.press_any_key(extra_text = false, action = '')
      require 'tty-prompt'
      if extra_text
        puts ''
        puts "/\\/\\ Check Values Above - About to Run (#{action}) /\\/\\".colorize(:yellow)
      end
      puts ''
      TTY::Prompt.new.keypress('Press any Key to Continue...')
    end

    def self.role_footer(item, run_time)
      puts '------------------------------------------------------------------------'.colorize(:light_green)
      puts 'Finished      ('.colorize(:light_green) + item.to_s.colorize(:cyan) + ')'.colorize(:light_green)
      puts 'Run Time:     ('.colorize(:light_green) + run_time.to_s.colorize(:cyan) + ')'.colorize(:light_green)
    end

    def self.sub_header(message)
      puts ''
      puts '*************************************************************************'.colorize(:light_green)
      puts '* '.colorize(:light_green) + message.to_s.colorize(:cyan)
      puts '*************************************************************************'.colorize(:light_green)
    end

    def self.sub_header_item(message, item)
      puts ''
      puts '*************************************************************************'.colorize(:light_green)
      puts '* '.colorize(:light_green) + message.to_s.colorize(:cyan) + ' ('.colorize(:light_green) + item.to_s.colorize(:yellow) + ')'.colorize(:light_green)
      puts '*************************************************************************'.colorize(:light_green)
    end

    def self.time_diff(start_time, end_time)
      Time.at((start_time - end_time).round.abs).utc.strftime('%H:%M:%S')
    end

    def self.warning_message(message)
      puts "WARNING: #{message.to_s.colorize(:yellow)}"
    end

    def self.warning_message_item(message, item)
      puts "WARNING: #{"#{message} (".colorize(:yellow)}#{item.to_s.colorize(:cyan)}#{')'.colorize(:yellow)}"
    end

    def self.warning_sub_header(message)
      puts ''
      puts '*************************************************************************'.colorize(:light_green)
      puts '* '.colorize(:light_green) + message.to_s.colorize(:yellow)
      puts '*************************************************************************'.colorize(:light_green)
    end
  end
end
