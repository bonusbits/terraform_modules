namespace :secrets do
  namespace :tf_vars do
    desc 'Create TFVars Secrets Files Locally'
    task :get_secrets_tfvars do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header('Create Secrets TFVars Files')
      Orchestrator::Secrets::TfVars.get_secrets_tfvars
    end
  end
end
