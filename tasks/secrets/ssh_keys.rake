namespace :secrets do
  namespace :ssh_keys do
    desc 'Generate RSA SSH PEM Keys that Terraform Can Upload to AWS'
    task :convert_rsa_key_to_pem, [:key_name] do |_task, args|
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header('Create SSH Keys')

      Orchestrator::Secrets::Folders.create_secrets_folders

      keys_path = "#{$project_vars['orchestrator']['secrets_path']}/#{$project_vars['terraform']['workspace']}"
      Orchestrator::Secrets::SshKeys.convert_rsa_key_to_pem(args[:key_name], keys_path)
    end

    desc 'Generate RSA SSH PEM Keys that Terraform Can Upload to AWS'
    task :create_ssh_key, [:key_name] do |_task, args|
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header('Create SSH Keys')

      Orchestrator::Secrets::Folders.create_secrets_folders

      keys_path = "#{$project_vars['orchestrator']['secrets_path']}/#{$project_vars['terraform']['workspace']}"
      Orchestrator::Secrets::SshKeys.create_rsa_key(args[:key_name], keys_path)
    end

    desc 'Generate EKS Node Group AWS SSH Keypair that Terraform Can Upload to AWS'
    task :create_ssh_keys_eks do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header_item('Create SSH Keypair', 'eks')

      Orchestrator::Secrets::Folders.create_secrets_folders

      keys_path = "#{$project_vars['orchestrator']['secrets_path']}/#{$project_vars['terraform']['workspace']}"
      Orchestrator::Secrets::SshKeys.create_rsa_key('eks', keys_path)
    end

    desc 'Get All SSH Keys from AWS Secrets Manager JSON Secret and Create Locally'
    task :get_ssh_keys do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header('Get All SSH Keys from AWS Secrets Manager JSON Secret and Create Locally')
      Orchestrator::Secrets::SshKeys.get_ssh_keys
    end
  end
end
