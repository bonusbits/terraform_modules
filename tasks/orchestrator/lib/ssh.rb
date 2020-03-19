module Orchestrator
  module Ssh
    # Run Shell Command Host over SSH and Returns realtime console outputs - Return Success true/false
    def self.run_command(host, user, ssh_key, command)
      require 'net/ssh'

      Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Ssh.run_command] host', host)
      Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Ssh.run_command] user', user)
      Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Ssh.run_command] ssh_key', ssh_key)
      Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Ssh.run_command] command', command)
      retries = 0
      code = nil
      # return_success = false
      Net::SSH.start(
        host, user,
        host_key: 'ssh-rsa',
        keys: [ssh_key],
        verify_host_key: :never
      ) do |ssh|
        the_channel = ssh.open_channel do |channel|
          Orchestrator::ConsoleOutputs.debug_message('[Orchestrator::Ssh.run_command] inside channel')
          channel.exec command do |ch, success|
            # raise 'could not execute command' unless success
            abort Orchestrator::ConsoleOutputs.error_message('Command Failed') unless success

            ch.on_data { |_c, data| print data }
            ch.on_extended_data { |_c, _type, data| print data }
            ch.on_request('exit-status') { |_ch, data| code = data.read_long }
          end
        end
        the_channel.wait
      end
      # abort "#{command} returned #{code} !!" if code != 0
      code.zero?
    rescue Net::SSH::ConnectionTimeout
      Orchestrator::ConsoleOutputs.error_message('Net::SSH::ConnectionTimeout')
      retry if (retries += 1) < 10
    end

    # def ssh_exec!(ssh, command)
    #   stdout_data = ''
    #   stderr_data = ''
    #   exit_code = nil
    #   exit_signal = nil
    #   ssh.open_channel do |channel|
    #     channel.exec(command) do |ch, success|
    #
    #       abort 'FAILED: could not execute command (ssh.channel.exec)' unless success
    #
    #       ch.on_data do |_c, data|
    #         stdout_data += data
    #       end
    #
    #       ch.on_extended_data do |_c, _type, data|
    #         stderr_data += data
    #       end
    #
    #       ch.on_request('exit-status') do |_c, data|
    #         exit_code = data.read_long
    #       end
    #
    #       ch.on_request('exit-signal') do |_c, data|
    #         exit_signal = data.read_long
    #       end
    #     end
    #   end
    #   ssh.loop
    #   [stdout_data, stderr_data, exit_code, exit_signal]
    # end

    # Run Shell Command Host over SSH and Returns realtime console outputs - Return Success true/false
    # def self.run_command2(host, user, ssh_key, command)
    #   require 'rubygems'
    #   require 'net/ssh'
    #   require 'etc'
    #
    #   Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Ssh.run_command] host', host)
    #   Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Ssh.run_command] user', user)
    #   Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Ssh.run_command] ssh_key', ssh_key)
    #   Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Ssh.run_command] command', command)
    #
    #   Net::SSH.start(
    #     host,
    #     user,
    #     host_key: 'ssh-rsa',
    #     keys: [ssh_key],
    #     verify_host_key: :never
    #   ) do |ssh|
    #     puts ssh_exec!(ssh, command).inspect
    #     # => ["", "", 0, nil]
    #
    #     puts ssh_exec!(ssh, command).inspect
    #     # => ["", "", 1, nil]
    #   end
    #
    # rescue Net::SSH::ConnectionTimeout
    #   Orchestrator::ConsoleOutputs.error_message('Net::SSH::ConnectionTimeout')
    #   retry if (retries += 1) < 10
    # end

    # TODO: WIP
    def self.tunnel_options(host, ssh_key_path, user = 'ubuntu')
      options = Hash.new
      key_path = "#{$project_vars['orchestrator']['secrets_path']}/#{$project_vars['terraform']['workspace']}"
      options['bastion_ip'] = Orchestrator::Terraform::Fetch.bastion_ip
      options['bastion_user'] = $project_vars['bastion']['login_user']
      options['bastion_ssh_key'] = "#{key_path}/#{$project_vars['bastion']['ssh_key_name']}"
      Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Shell.ssh_tunnel_options] Bastion IP', options['bastion_ip'].to_s)
      Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Shell.ssh_tunnel_options] SSH Tunnel Options Host Name', host.to_s)

      options['private_ip'] = Orchestrator::Terraform::Fetch.instance_ip(host)
      options['private_user'] = user
      options['private_ssh_key'] = ssh_key_path
      Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Shell.ssh_tunnel_options] Instance IP', options['private_ip'].to_s)
      Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Shell.ssh_tunnel_options] Using SSH Key Pair', options['private_ssh_key'].to_s)
      options
    end

    # TODO: WIP
    # Run Shell Command on Private host Tunneled through Bastion Host over SSH and Returns realtime console outputs
    def self.run_command_bastion_tunnel(host, command)
      require 'net/ssh/gateway'
      options = Orchestrator::Ssh.tunnel_options(host)

      retries = 0
      code = nil

      gateway = Net::SSH::Gateway.new(options['bastion_ip'], options['bastion_user'],
                                      forward_agent: true,
                                      keys: [options['bastion_ssh_key']],
                                      host_key: 'ssh-rsa',
                                      port: 22,
                                      verify_host_key: :never,
                                      timeout: 1)

      gateway.open(options['private_ip'], 22) do |_gateway_port|
        gateway.ssh(options['private_ip'], options['private_user'],
                    keys: options['private_ssh_key'],
                    host_key: 'ssh-rsa',
                    port: 22,
                    verify_host_key: :never,
                    timeout: 1) do |ssh|
          the_channel = ssh.open_channel do |channel|
            channel.exec command do |ch, success|
              raise 'could not execute command' unless success

              ch.on_data { |_c, data| print data }
              ch.on_extended_data { |_c, _type, data| print data }
              ch.on_request('exit-status') { |_ch, data| code = data.read_long }
            end
          end
          the_channel.wait
        end
      end
      gateway.shutdown!
      return "ERROR: Command (#{command}) Returned Code (#{code})!!" unless code == 0 # rubocop:disable Style/NumericPredicate

      Orchestrator::ConsoleOutputs.info_message('Command Success!')
    rescue Net::SSH::ConnectionTimeout
      Orchestrator::ConsoleOutputs.error_message('[Orchestrator::Ssh.run_command_bastion_tunnel] Net::SSH::ConnectionTimeout')
      retry if (retries += 1) < 10
    end
  end
end
