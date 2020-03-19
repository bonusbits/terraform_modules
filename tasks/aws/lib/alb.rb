module Orchestrator
  module AWS
    module ALB
      def self.alb_client
        require 'aws-sdk-elasticloadbalancingv2'
        Aws::ElasticLoadBalancingV2::Client.new(
          region: $project_vars['aws']['region'],
          profile: $project_vars['aws']['profile']
        )
        # alb_client = Aws::ElasticLoadBalancingV2::Client.new(region: 'us-east-1', profile: 'bonusbits')
      end

      def self.check_target_health(target_group_arn)
        alb_client = Orchestrator::AWS::ALB.alb_client
        begin
          retries ||= 0
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::ALB.check_target_health] retries', retries)
          describe_target_health_response = alb_client.describe_target_health(target_group_arn: target_group_arn)
        rescue StandardError => e
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::ALB.check_target_health]  Standard Error Output', e)
          Orchestrator::ConsoleOutputs.error_message_item('[Orchestrator::AWS::ALB.check_target_health] - Rescue', retries)
          sleep 1
          retry if (retries += 1) < 10
        end
        results = describe_target_health_response.target_health_descriptions[0].target_health.state
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::ALB.check_target_health] Return', results)
        results
      end

      def self.check_target_group_health_loop(target, target_group_arn)
        loop_count = 0
        target_health = 'UNKNOWN'
        print 'Checking Status '
        # Loop for 180 (15 minutes) Max checking if Target Group Healthy
        until loop_count >= 180 || target_health == 'healthy'
          loop_count += 1
          print '.'
          target_health = Orchestrator::AWS::ALB.check_target_health(target_group_arn)
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::ALB.check_target_group_health_loop] Loops Count', loop_count)
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::ALB.check_target_group_health_loop] Target', target)
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::ALB.check_target_group_health_loop] Target Health', target_health)
          sleep 5 unless target_health == 'healthy'
        end

        puts ''
        if target_health == 'healthy'
          Orchestrator::ConsoleOutputs.info_message_item('Target Group', target_health)
          true
        else
          Orchestrator::ConsoleOutputs.error_message_item('[Orchestrator::AWS::ALB.check_target_group_health_loop] Target Health', target_health)
          false
        end
      end

      def self.describe_listener_rules(listener_arn)
        alb_client = Orchestrator::AWS::ALB.alb_client
        begin
          retries ||= 0
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::ALB.describe_listener_rules] retries', retries)
          alb_client.describe_rules(
            listener_arn: listener_arn
          )
        rescue StandardError => e
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::ALB.describe_listener_rules]  Standard Error Output', e)
          Orchestrator::ConsoleOutputs.error_message_item('[Orchestrator::AWS::ALB.describe_listener_rules] - Rescue', retries)
          sleep 1
          retry if (retries += 1) < 10
        end
      end

      def self.delete_listener_rule(rule_arn)
        # https://docs.aws.amazon.com/sdk-for-ruby/v2/api/Aws/ElasticLoadBalancingV2/Client.html#delete_rule-instance_method
        alb_client = Orchestrator::AWS::ALB.alb_client

        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::ALB.delete_listener_rule] rule_arn', rule_arn)
        begin
          retries ||= 0
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::ALB.delete_listener_rule] retries', retries)
          alb_client.delete_rule(
            rule_arn: rule_arn
          )
        rescue StandardError => e
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::ALB.delete_listener_rule]  Standard Error Output', e)
          Orchestrator::ConsoleOutputs.error_message_item('[Orchestrator::AWS::ALB.delete_listener_rule] - Rescue', retries)
          sleep 1
          retry if (retries += 1) < 10
        end
      end

      # Return List of Target Group ARN Based on VPC ID
      def self.target_group_arns(vpc_id)
        alb_client = Orchestrator::AWS::ALB.alb_client
        begin
          retries ||= 0
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::ALB.target_group_arns] retries', retries)
          all_tgs = alb_client.describe_target_groups.to_h[:target_groups]

          tg_arn_list = Array.new
          all_tgs.each do |values|
            tg_arn_list.push(values[:target_group_arn]) if values[:vpc_id] == vpc_id
          end
        rescue StandardError => e
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::ALB.target_group_arns]  Standard Error Output', e)
          Orchestrator::ConsoleOutputs.error_message_item('[Orchestrator::AWS::ALB.target_group_arns] - Rescue', retries)
          sleep 1
          retry if (retries += 1) < 10
        end
        tg_arn_list
      end

      # Return just the Target Group ARNs for K8S ALBs in the VPC
      def self.target_group_arns_k8s(vpc_id)
        all_tg_arn_list = Orchestrator::AWS::ALB.target_group_arns(vpc_id)
        k8s_arn_list = all_tg_arn_list.select { |values| values[/k8s-/] }

        tg_hash = Hash.new
        k8s_arn_list.each do |tg_arn|
          tg_hash[tg_arn.split('/')[1]] = tg_arn
        end
        tg_hash
      end
    end
  end
end
