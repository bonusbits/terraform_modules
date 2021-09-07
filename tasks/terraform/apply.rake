namespace :terraform do
  desc 'Run Terraform Apply - (rake terraform:apply, rake terraform:apply[bastion])'
  task :apply, [:role] do |_task, args|
    Orchestrator::ConsoleOutputs.header

    skip_all_prompts = $project_vars['orchestrator']['feature_toggles']['skip_all_prompts'].nil? ? false : $project_vars['orchestrator']['feature_toggles']['skip_all_prompts']

    if args[:role].nil?
      $project_vars['terraform']['roles'].each do |role|
        Orchestrator::ConsoleOutputs.sub_header_item('Terraform Apply', role)
        Orchestrator::ConsoleOutputs.debug_message('[terraform:apply] args[:role].nil? = true')
        Orchestrator::ConsoleOutputs.debug_message('[terraform:apply] Iterating over terraform:roles list')
        Orchestrator::ConsoleOutputs.debug_message_item('[terraform:apply] role', role)
        next unless skip_all_prompts || Orchestrator::ConsoleOutputs.highline_prompt_yellow("Continue with #{role}")

        start_time = Time.now
        Dir.chdir("#{$project_vars['orchestrator']['orchestrator_path']}/terraform/environments/#{$project_vars['orchestrator']['environment']}/#{role}") do
          Orchestrator::ConsoleOutputs.debug_message_item('[terraform:apply] Starting Apply', role)
          Orchestrator::Terraform::Cli.terraform_tfvars_command('apply -auto-approve -parallelism=10 -refresh=true -compact-warnings', role)
          Orchestrator::ConsoleOutputs.debug_message_item('[terraform:apply] Finished Apply', role)
        end
        Orchestrator::ConsoleOutputs.debug_message_item('[terraform:apply] Finished Case', role)
        end_time = Time.now
        run_time = Orchestrator::ConsoleOutputs.time_diff(start_time, end_time)
        Orchestrator::ConsoleOutputs.role_footer(role, run_time)
      end
    else
      Orchestrator::ConsoleOutputs.debug_message_item('[terraform:apply] args[:role] received', args[:role])
      Orchestrator::ConsoleOutputs.sub_header_item('Terraform Apply Role', args[:role])
      Orchestrator::Terraform::Cli.terraform_tfvars_command_path('apply -auto-approve -parallelism=10 -refresh=true -compact-warnings', args[:role])
    end
  end
end

desc 'Alias (terraform:apply[item])'
task :apply, [:role] do |_task, args|
  Rake::Task['terraform:apply'].invoke(args[:role])
end
