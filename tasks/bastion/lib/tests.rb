module Orchestrator
  module Bastion
    module Tests
      def self.instance_status_loop
        instance_id = Orchestrator::Bastion::Terraform.instance_id
        Orchestrator::AWS::EC2.check_instance_status_loop(instance_id)
      end

      def self.tail_cloud_init_loop
        raise Orchestrator::ConsoleOutputs.error_message('Missing Rake Config bastion:login_user') if $project_vars['bastion']['login_user'].nil?
        raise Orchestrator::ConsoleOutputs.error_message('Missing Rake Config bastion:ssh_key_name') if $project_vars['bastion']['ssh_key_name'].nil?

        loop_count = 0
        max_loops = 300 # 300 * 2 = 600 sec = 10 min
        sleep_time = 2
        success = false
        bastion_ip = Orchestrator::Bastion::Terraform.bastion_ip
        key_path = "#{$project_vars['orchestrator']['secrets_path']}/#{$project_vars['terraform']['workspace']}/#{$project_vars['bastion']['ssh_key_name']}"

        # command = '[[ -f "/var/log/cloud-init-output.log" ]] && sudo grep -q "USER DATA COMPLETED" /var/log/cloud-init-output.log'
        command = '[[ -f "/var/log/cloud-init-output.log" ]] && sudo grep -q "BOGUS" /var/log/cloud-init-output.log'
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Bastion::Tests.tail_cloud_init_loop] command', command)

        print 'Checking Status '
        until loop_count >= max_loops || success
          loop_count += 1
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Bastion::Tests.tail_cloud_init_loop] loop_count', loop_count)
          print '.'
          success = Orchestrator::Ssh.run_command(bastion_ip, $project_vars['bastion']['login_user'], key_path, command)
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Bastion::Tests.tail_cloud_init_loop] success', success)
          sleep sleep_time unless success
        end

        puts ''
        if success
          Orchestrator::ConsoleOutputs.info_message('Cloud Init Completed')
        else
          Orchestrator::ConsoleOutputs.error_message_item('Cloud Init Not Completed. Max Loops Exceeded', max_loops)
        end
      end

      # def self.tail_cloud_init
      #   raise Orchestrator::ConsoleOutputs.error_message('Missing Rake Config bastion:login_user') if $project_vars['bastion']['login_user'].nil?
      #   raise Orchestrator::ConsoleOutputs.error_message('Missing Rake Config bastion:ssh_key_name') if $project_vars['bastion']['ssh_key_name'].nil?
      #
      #   command = 'tail -f \'/var/log/cloud-init-output.log\' | while read line; do echo $line; [[ "$line" == "USER DATA COMPLETED" ]] && pkill tail; done'
      #
      #   # command = <<-TAIL
      #   # tail -f '/var/log/cloud-init-output.log' | while read line
      #   # do
      #   #   echo $line
      #   #   [[ "$line" == 'USER DATA COMPLETED' ]] && pkill tail && echo '' && echo "INFO: Cloud Init Completed"
      #   # done
      #   # TAIL
      #
      #   # command = <<-TAIL
      #   #   cloud_init_log="/var/log/cloud-init-output.log"
      #   #
      #   #   if [[ -f "$cloud_init_log" ]]; then
      #   #     if (timeout 300s tail -F "$cloud_init_log" &) | grep -q "USER DATA COMPLETED" ; then
      #   #         echo "INFO: Cloud Init Completed"
      #   #     else
      #   #         echo "ERROR: Cloud Init Failed!"
      #   #         echo "ERROR: Cloud Init Output Loop Timeout Exceeded"
      #   #         tail stderr.log stdout.log
      #   #         exit 1
      #   #     fi
      #   #   else
      #   #     echo "ERROR: Cloud Init Output Log Not Found!"
      #   #     exit 1
      #   #   fi
      #   # TAIL
      #
      #   bastion_ip = Orchestrator::Bastion::Terraform.bastion_ip
      #   key_path = "#{$project_vars['orchestrator']['secrets_path']}/#{$project_vars['terraform']['workspace']}/#{$project_vars['bastion']['ssh_key_name']}"
      #
      #   # Orchestrator::Ssh.run_command(bastion_ip, $project_vars['bastion']['login_user'], key_path, command)
      #   exit_code = Orchestrator::Ssh.run_command(bastion_ip, $project_vars['bastion']['login_user'], key_path, command)
      #   Orchestrator::ConsoleOutputs.debug_message_item('Command Finished Exit Code', exit_code)
      # end

      # def self.tail_cloud_init_via_bastion(host_name)
      #   raise Orchestrator::ConsoleOutputs.error_message('Missing Rake Config bastion:login_user') if $project_vars['bastion']['login_user'].nil?
      #   raise Orchestrator::ConsoleOutputs.error_message('Missing Rake Config bastion:ssh_key_name') if $project_vars['bastion']['ssh_key_name'].nil?
      #
      #   command = <<-TAIL
      #   tail -f '/var/log/cloud-init-output.log' | while read line
      #   do
      #     echo $line
      #     [[ "$line" == 'USER DATA COMPLETED' ]] && pkill tail && echo '' && echo "INFO: Cloud Init Completed"
      #   done
      #   TAIL
      #   Orchestrator::ConsoleOutputs.sub_header_item('Tail Cloud Init Log on', host_name)
      #   Orchestrator::Ssh.run_command_bastion_tunnel(host_name, command)
      # end
    end
  end
end
