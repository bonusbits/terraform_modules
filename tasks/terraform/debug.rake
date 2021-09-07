namespace :terraform do
  namespace :debug do
    desc 'Show Terraform CLI Common Vars'
    task :show_common_vars do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header('Terraform CLI Common Vars')
      Orchestrator::Terraform::Vars.show_common_vars
    end

    desc 'Fetch and Show Terraform Outputs'
    task :show_all_terraform_outputs do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header('All Terraform Outputs')
      Orchestrator::Terraform::Fetch.all_state_outputs
      puts $all_terraform_states
    end

    desc 'Fetch and Show Terraform Output Keys'
    task :show_all_terraform_outputs_keys do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header('All Terraform Output Keys')
      Orchestrator::Terraform::Fetch.all_state_outputs
      puts $all_terraform_states.keys
    end

    desc 'Show Project Rake Terraform Import Variables from Yaml Files'
    task :show_import_vars do
      Orchestrator::Terraform::Vars.load_import_maps
      Orchestrator::Terraform::Vars.show_import_vars
    end

    desc 'Show Project Rake Terraform Import Variables from for Single Yaml File - (rake terraform:debug:show_import_vars_single[before_split]) '
    task :show_import_vars_single, [:map] do |_task, args|
      Orchestrator::Terraform::Vars.show_import_vars_single(args[:map])
    end

    desc 'Show Project Rake Terraform Import Variables from Yaml Files'
    task :show_import_var_keys do
      Orchestrator::Terraform::Vars.load_import_maps
      Orchestrator::Terraform::Vars.show_import_var_keys
    end
  end
end

desc 'Alias (terraform:debug:show_common_vars)'
task show_terraform_common_vars: %w[terraform:debug:show_common_vars]

desc 'Alias (terraform:debug:show_import_vars)'
task show_import_vars: %w[terraform:debug:show_import_vars]
