namespace :bastion do
  namespace :secrets do
    desc 'Generate Bastion EC2 Instance SSH Keypair that Terraform Can Upload to AWS'
    task :create_ssh_key do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header_item('Create SSH Keypair', 'bastion')

      Orchestrator::Secrets::Folders.create_secrets_folders

      keys_path = "#{$project_vars['orchestrator']['secrets_path']}/#{$project_vars['terraform']['workspace']}"
      Orchestrator::Secrets::SshKeys.create_rsa_key($project_vars['bastion']['ssh_key_name'], keys_path)
    end
  end
end
