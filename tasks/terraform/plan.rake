namespace :terraform do
  desc 'Run Terraform Plan - (rake terraform:plan, rake terraform:plan[network])'
  task :plan, [:role] do |_task, args|
    Orchestrator::Terraform::Cli.command_tfvars('plan', 'Terraform Plan', args[:role])
  end
end

desc 'Alias (terraform:plan[role])'
task :plan, [:role] do |_task, args|
  Rake::Task['terraform:plan'].invoke(args[:role])
end
