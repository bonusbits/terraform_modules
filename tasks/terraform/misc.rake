namespace :terraform do
  desc 'Run Terraform Console'
  task :console, [:role] do |_task, args|
    if args[:role].nil?
      Orchestrator::Terraform::Cli.command_tfvars('console', 'Terraform Console', $project_vars['terraform']['roles'].first)
    else
      Orchestrator::Terraform::Cli.command_tfvars('console', 'Terraform Console', args[:role])
    end
  end

  desc 'Validate Terraform Configurations'
  task :validate, [:role] do |_task, args|
    Orchestrator::Terraform::Cli.command('validate', 'Terraform Validate', args[:role])
  end

  desc 'Display Terraform Workspaces'
  task :workspaces do
    Orchestrator::Terraform::Cli.command('workspace list', 'Terraform Workspace', $project_vars['terraform']['roles'].first)
  end
end
