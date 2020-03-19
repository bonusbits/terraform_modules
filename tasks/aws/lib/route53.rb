module Orchestrator
  module AWS
    module Route53
      # https://docs.aws.amazon.com/sdk-for-ruby/v2/api/Aws/Route53/Client.html#change_resource_record_sets-instance_method
      def self.r53_client
        require 'aws-sdk-route53'
        Aws::Route53::Client.new(
          region: $project_vars['aws']['region'],
          profile: $project_vars['aws']['profile']
        )
        # client = Aws::Route53::Client.new(region: 'us-east-1', profile: 'bonusbits')
      end

      def self.update_cname(change_set)
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::Route53.update_cname] change_set', change_set)
        r53_client = Orchestrator::AWS::Route53.r53_client
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::Route53.update_cname] r53_client', r53_client.config.to_h)
        resp = r53_client.change_resource_record_sets(change_set)
        Orchestrator::ConsoleOutputs.message(resp.to_s)
      end
    end
  end
end
