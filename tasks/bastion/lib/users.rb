module Orchestrator
  module Bastion
    def self.add_users
      bastion_user_list = Dir.children("#{$project_vars['orchestrator']['secrets_path']}/#{$project_vars['terraform']['workspace']}/bastion_users")
      key_path = "#{$project_vars['orchestrator']['secrets_path']}/#{$project_vars['terraform']['workspace']}"
      bastion_ssh_key = "#{key_path}/#{$project_vars['bastion']['ssh_key_name']}"
      bastion_ip = Orchestrator::Terraform::Fetch.bastion_ip
      all_commands = String.new
      bastion_user_list.each do |username|
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Bastion.add_users] each.username', username)
        key_file_path = "#{$project_vars['orchestrator']['secrets_path']}/bastion_users/#{username}"
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Bastion.add_users] key_file_path', key_file_path)
        username_hyphen = username.sub('.', '-').sub('_', '-')
        key_file_contents = File.read(key_file_path)
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Bastion.add_users] key_file_contents', key_file_contents)

        # Create User if Missing
        c1 = "if id -u '#{username}' >/dev/null 2>&1; then echo 'INFO: User Already Exists (#{username})'; else sudo useradd -m -s /bin/bash '#{username}'; fi"

        # Add SSH Auth Public Key
        c2 = <<-AUTHKEYS
        if sudo bash -c '[[ ! -a /home/#{username}/.ssh/authorized_keys ]]'; then
          echo "INFO: Adding User Auth Keys (/home/#{username}/.ssh/authorized_keys)"
          sudo -u #{username} mkdir -p /home/#{username}/.ssh
          sudo -u #{username} echo '#{key_file_contents}' > /tmp/#{username}.keys
          sudo -u root chmod 0600 /tmp/#{username}.keys
          sudo -u root chown #{username}:#{username} /tmp/#{username}.keys
          sudo -u root mv /tmp/#{username}.keys /home/#{username}/.ssh/authorized_keys
          sudo -u #{username} chmod 0700 /home/#{username}/.ssh
        else
          echo "INFO: User Auth Keys File Already Exists (/home/#{username}/.ssh/authorized_keys)"
        fi
        AUTHKEYS

        # Add User to Sudoers
        c3 = <<-SUDOERSD
        if sudo bash -c '[[ ! -a /etc/sudoers.d/100-#{username_hyphen} ]]'; then
          echo "INFO: Adding sudoers.d File (/etc/sudoers.d/100-#{username_hyphen})"
          sudo -u root rm -f /tmp/100-#{username_hyphen}
          sudo -u root echo '#{username} ALL=(ALL) NOPASSWD:ALL' >> /tmp/100-#{username_hyphen}
          sudo -u root chown -R  #{username}:#{username} /home/#{username}/.ssh
          sudo -u root chown root:root /tmp/100-#{username_hyphen}
          sudo -u root chmod 0440 /tmp/100-#{username_hyphen}
          sudo -u root mv /tmp/100-#{username_hyphen} /etc/sudoers.d
        else
          echo "INFO: User Sudoers Config Already Exists (/etc/sudoers.d/100-#{username_hyphen})"
        fi
        SUDOERSD

        # Add SSH Config if Present
        ssh_config_path = "#{$project_vars['orchestrator']['secrets_path']}/#{$project_vars['terraform']['workspace']}/bastion_ssh_configs/#{username}"
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Bastion.add_users] ssh_config_path', ssh_config_path)
        if File.exist?(ssh_config_path)
          ssh_config_contents = File.read(ssh_config_path)
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Bastion.add_users] ssh_config_contents', ssh_config_contents)
          c4 = <<-SSHCONFIG
          if sudo bash -c '[[ ! -a /home/#{username}/.ssh/config ]]'; then
            echo "INFO: Adding User SSH Config (/home/#{username}/.ssh/config)"
            mkdir -p /tmp/#{username}
            cat <<'EOF' > /tmp/#{username}/config \n#{ssh_config_contents} \nEOF
            chmod 0644 /tmp/#{username}/config
            sudo -u root mv /tmp/#{username}/config /home/#{username}/.ssh/config
            sudo -u root chown #{username}:#{username} /home/#{username}/.ssh/config
          else
            echo "INFO: User SSH Config Already Exists (/home/#{username}/.ssh/config)"
          fi

          if sudo bash -c '[[ ! #{username} == "cronicle" ]]'; then
            sudo -u root cp /root/.ssh/alma-instances /home/#{username}/.ssh/net_private
            sudo -u root chown #{username}:#{username} /home/#{username}/.ssh/net_private
          fi
          SSHCONFIG
          command_list = [c1, c2, c3, c4]
        else
          command_list = [c1, c2, c3]
        end
        command_list.each do |command|
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Bastion.add_users] Executing Command', command)
          all_commands << command
          all_commands << "\n"
        end
      end
      Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Bastion.add_users] all_commands', all_commands)
      Orchestrator::Ssh.run_command(bastion_ip, $project_vars['bastion']['login_user'], bastion_ssh_key, all_commands)
    end
  end
end
