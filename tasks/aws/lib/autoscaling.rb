module Orchestrator
  module AWS
    module Autoscaling
      def self.asg_client
        require 'aws-sdk-autoscaling'
        Aws::AutoScaling::Client.new(
          region: $project_vars['aws']['region'],
          profile: $project_vars['aws']['profile']
        )
        # autoscaling_client = Aws::AutoScaling::Client.new(region: 'us-east-1', profile: 'bonusbits')
      end

      def self.disable_alarm_scaling(group_id)
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::Autoscaling.disable_alarm_scaling] group_id', group_id)
        autoscaling_client = Orchestrator::AWS::Autoscaling.asg_client
        begin
          retries ||= 0
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::Autoscaling.disable_alarm_scaling] retries', retries)
          resp = autoscaling_client.suspend_processes(
            auto_scaling_group_name: group_id,
            scaling_processes: [
              'AlarmNotification'
            ]
          )
        rescue StandardError => e
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::Autoscaling.disable_alarm_scaling]  Standard Error Output', e)
          Orchestrator::ConsoleOutputs.error_message_item('[Orchestrator::AWS::Autoscaling.disable_alarm_scaling] - Rescue', retries)
          sleep 1
          retry if (retries += 1) < 10
        end

        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::Autoscaling.disable_alarm_scaling] response', resp)
      end

      def self.disable_all_scaling(group_id)
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::Autoscaling.disable_all_scaling] group_id', group_id)
        autoscaling_client = Orchestrator::AWS::Autoscaling.asg_client
        begin
          retries ||= 0
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::Autoscaling.disable_alarm_scaling] retries', retries)
          resp = autoscaling_client.suspend_processes(
            auto_scaling_group_name: group_id,
            scaling_processes: %w[
              AddToLoadBalancer
              AlarmNotification
              AZRebalance
              HealthCheck
              InstanceRefresh
              Launch
              ReplaceUnhealthy
              Terminate
              ScheduledActions
            ]
          )
        rescue StandardError => e
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::Autoscaling.disable_alarm_scaling]  Standard Error Output', e)
          Orchestrator::ConsoleOutputs.error_message_item('[Orchestrator::AWS::Autoscaling.disable_alarm_scaling] - Rescue', retries)
          sleep 1
          retry if (retries += 1) < 10
        end
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::Autoscaling.disable_alarm_scaling] response', resp)
      end

      def self.enable_scaling_processes(group_id)
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::Autoscaling.enable_scaling_processes] group_id', group_id)
        autoscaling_client = Orchestrator::AWS::Autoscaling.asg_client

        begin
          retries ||= 0
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::Autoscaling.enable_scaling_processes] retries', retries)
          resp = autoscaling_client.resume_processes(
            auto_scaling_group_name: group_id,
            scaling_processes: []
          )
        rescue StandardError => e
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::Autoscaling.enable_scaling_processes]  Standard Error Output', e)
          Orchestrator::ConsoleOutputs.error_message_item('[Orchestrator::AWS::Autoscaling.enable_scaling_processes] - Rescue', retries)
          sleep 1
          retry if (retries += 1) < 10
        end
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::Autoscaling.enable_scaling_processes] response', resp)
      end

      def self.group_instance_ids(group_id)
        autoscaling_client = Orchestrator::AWS::Autoscaling.asg_client
        begin
          retries ||= 0
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::Autoscaling.group_instance_ids] retries', retries)
          asg = autoscaling_client.describe_auto_scaling_groups(auto_scaling_group_names: [group_id.to_s])
        rescue StandardError => e
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::Autoscaling.group_instance_ids]  Standard Error Output', e)
          Orchestrator::ConsoleOutputs.error_message_item('[Orchestrator::AWS::Autoscaling.group_instance_ids] - Rescue', retries)
          sleep 1
          retry if (retries += 1) < 10
        end
        instances = asg[0][0].instances
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::Autoscaling.group_instance_ids] instances', instances)
        instance_ids = Array.new
        instances.each { |instance|; instance_ids << instance['instance_id']; }
        # require 'pp'
        # require 'pry'
        # Pry::ColorPrinter.pp(asg_hash)
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::Autoscaling.group_instance_ids] instance_ids', instance_ids)
        instance_ids # Array
      end

      def self.group_instances_ip_addresses(group_id)
        instance_ids = Orchestrator::AWS::Autoscaling.group_instance_ids(group_id)
        ip_addresses = Array.new
        instance_ids.each do |instance_id|
          ip_addresses << Orchestrator::AWS::EC2.instance_private_ip(instance_id)
        end
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::Autoscaling.group_instances_ip_addresses] Return', ip_addresses)
        ip_addresses # Array
      end
    end
  end
end
