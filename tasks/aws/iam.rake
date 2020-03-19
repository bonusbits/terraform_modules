namespace :aws do
  namespace :iam do
    desc 'Current AWS Account ID'
    task :current_user_account_id do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header('Current AWS Account ID')
      aws_account_id = Orchestrator::AWS::Iam.current_user_account_id
      Orchestrator::ConsoleOutputs.message_item('AWS Account ID', aws_account_id)
    end

    desc 'Current IAM User ARN'
    task :current_user_arn do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header('Current IAM User ARN')
      current_user_arn = Orchestrator::AWS::Iam.current_user_arn
      Orchestrator::ConsoleOutputs.message_item('Current User IAM ARN', current_user_arn)
    end
  end
end
