module Orchestrator
  module AWS
    module Iam
      def self.iam_current_user(region = $project_vars['aws']['region'], profile = $project_vars['aws']['profile'])
        require 'aws-sdk-iam'

        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.ec2_client] region', region)
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.ec2_client] profile', profile)

        Aws::IAM::CurrentUser.new(
          region: region,
          profile: profile
        )
        # require 'aws-sdk-iam'
        # iam_current_user = Aws::IAM::CurrentUser.new(region: 'us-west-2', profile: 'bonusbits')
      end

      def self.current_user_account_id
        current_user_arn = Orchestrator::AWS::Iam.current_user_arn
        aws_account_id = current_user_arn.split(':')[4]
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::Account.current_user_account_id] current_user_arn', aws_account_id)
        aws_account_id
      end

      def self.current_user_arn
        iam_current_user = Orchestrator::AWS::Iam.iam_current_user
        current_user_arn = iam_current_user.arn
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::Account.current_user_arn] current_user_arn', current_user_arn)
        current_user_arn
      end
    end
  end
end
