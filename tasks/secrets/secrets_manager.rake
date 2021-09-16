namespace :secrets do
  namespace :secrets_manager do
    desc 'Generate Secrets JSON File Locally for AWS Secrets Manager Upload'
    task :generate_secrets_json, [:ssh_key_list, :overwrite] do |_task, args|
      args.with_defaults(ssh_key_list: %w[bastion eks], overwrite: false)
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header_item('Generate Secrets JSON File Locally', "overwrite:#{args[:overwrite]}")
      Orchestrator::Secrets::TfVars.generate_secrets_json(args[:overwrite], args[:overwrite])
    end

    desc 'Generate and Upload Secrets JSON to AWS Secrets Manager'
    task :generate_and_upload_secrets, [:ssh_key_list, :overwrite] do |_task, args|
      args.with_defaults(ssh_key_list: %w[bastion eks], overwrite: false)
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header_item('Generate Secrets JSON', "overwrite:#{args[:overwrite]}")
      Orchestrator::Secrets::TfVars.generate_secrets_json(args[:overwrite], args[:overwrite])
      Orchestrator::ConsoleOutputs.sub_header('Upload Secrets Value')
      Orchestrator::Secrets::SecretsManager.upload_secrets
    end

    desc 'Get TFVars Secrets and SSH Key Files and Create Locally from AWS Secrets Manager'
    task :get_secrets, [:overwrite] do |_task, args|
      args.with_defaults(overwrite: false)
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header_item('Get Secrets TFVars Files', "overwrite:#{args[:overwrite]}")
      Orchestrator::Secrets::TfVars.get_secrets_tfvars(args[:overwrite])
      Orchestrator::ConsoleOutputs.sub_header_item('Get SSH Keys from AWS Secrets Manager JSON Secret', "overwrite:#{args[:overwrite]}")
      Orchestrator::Secrets::SshKeys.get_ssh_keys(args[:overwrite])
    end

    desc 'Upload Secrets Value to AWS Secrets Manager'
    task :upload_secrets do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header('Upload Secrets Value')
      Orchestrator::Secrets::SecretsManager.upload_secrets
    end

    desc 'Display Value of Devops Secret for Current Stack'
    task :display_value_as_json do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header('Display Secrets Value as JSON')
      Orchestrator::Secrets::SecretsManager.display_value_as_json
    end

    desc 'Get Stack Secrets JSON'
    task :display_value_as_hash do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header('Get Stack Secrets JSON')
      Orchestrator::Secrets::SecretsManager.display_value_as_hash
    end
  end
end

desc 'Alias (secrets:secrets_manager:get_secrets)'
task :get_secrets, [:overwrite] do |_task, args|
  args.with_defaults(overwrite: false)
  Rake::Task['secrets:secrets_manager:get_secrets'].invoke(args[:overwrite])
end

desc 'Alias (secrets:secrets_manager:upload_secrets)'
task upload_secrets: %w[secrets:secrets_manager:upload_secrets]
