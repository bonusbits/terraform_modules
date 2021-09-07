namespace :terraform do
  desc 'Refresh Terraform State - (rake terraform:refresh, rake terraform:refresh[bastion])'
  task :refresh, [:role] do |_task, args|
    Orchestrator::Terraform::Cli.command_tfvars('refresh', 'Terraform Refresh', args[:role])
  end
end

desc 'Alias (terraform:refresh[item])'
task :refresh, [:role] do |_task, args|
  Rake::Task['terraform:refresh'].invoke(args[:role])
end
