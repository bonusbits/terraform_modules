namespace :secrets do
  namespace :folders do
    desc 'Create Secrets Folder Locally'
    task :create_secrets_folders do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header_item('Creating Secrets Folder', $project_vars['terraform']['workspace'])
      Orchestrator::Secrets::Folders.create_secrets_folders
    end
  end
end

desc 'Alias (secrets:folders:create_secrets_folders)'
task create_secrets_folder: %w[secrets:folders:create_secrets_folders]
