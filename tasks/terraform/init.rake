namespace :terraform do
  desc 'Run Terraform Initialization - (rake terraform:init, rake terraform:init[bastion])'
  task :init, [:role] do |_task, args|
    backend_config = Orchestrator::Terraform::Cli.load_backend_vars
    Orchestrator::Terraform::Cli.command_tfvars("init #{backend_config['backend_bucket']} #{backend_config['backend_region']} #{backend_config['backend_key_prefix']}", 'Terraform Init', args[:role])
  end

  desc 'Run Terraform Initialization with Migrate State - (rake terraform:init_migrate_state, rake terraform:init_migrate_state[bastion])'
  task :init_migrate_state, [:role] do |_task, args|
    backend_config = Orchestrator::Terraform::Cli.load_backend_vars
    Orchestrator::Terraform::Cli.command_tfvars("init -migrate-state #{backend_config['backend_bucket']} #{backend_config['backend_region']} #{backend_config['backend_key_prefix']}", 'Terraform Init Migrate State', args[:role])
  end

  desc 'Run Terraform Initialization with Reconfigure - (rake terraform:init_reconfigure, rake terraform:init_reconfigure[bastion])'
  task :init_reconfigure, [:role] do |_task, args|
    backend_config = Orchestrator::Terraform::Cli.load_backend_vars
    Orchestrator::Terraform::Cli.command_tfvars("init -reconfigure #{backend_config['backend_bucket']} #{backend_config['backend_region']} #{backend_config['backend_key_prefix']}", 'Terraform Init Reconfigure', args[:role])
  end

  desc 'Upgrade Terraform Providers - (rake terraform:init_upgrade, rake terraform:init_upgrade[network])'
  task :init_upgrade, [:role] do |_task, args|
    backend_config = Orchestrator::Terraform::Cli.load_backend_vars
    Orchestrator::Terraform::Cli.command_tfvars("init -upgrade #{backend_config['backend_bucket']} #{backend_config['backend_region']} #{backend_config['backend_key_prefix']}", 'Terraform Init Upgrade', args[:role])
  end
end

desc 'Alias (terraform:init[role])'
task :init, [:role] do |_task, args|
  Rake::Task['terraform:init'].invoke(args[:role])
end

desc 'Alias (terraform:init_reconfigure[role])'
task :init_reconfigure, [:role] do |_task, args|
  Rake::Task['terraform:init_reconfigure'].invoke(args[:role])
end

desc 'Alias (terraform:init_upgrade[role])'
task :init_upgrade, [:role] do |_task, args|
  Rake::Task['terraform:init_upgrade'].invoke(args[:role])
end
