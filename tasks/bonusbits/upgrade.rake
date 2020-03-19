namespace :bonusbits do
  namespace :upgrade do
    desc 'Upgrade the Bonus Bits Web App Services'
    task :stack do
      require 'highline/import'
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header('Upgrade App Services')

      start_time = Time.now
      skip_all_prompts = $project_vars['orchestrator']['feature_toggles']['skip_all_prompts'].nil? ? false : $project_vars['orchestrator']['feature_toggles']['skip_all_prompts']
      Orchestrator::ConsoleOutputs.warning_sub_header('Rake Var Set (Skip All Prompts)') if skip_all_prompts

      next unless Orchestrator::ConsoleOutputs.highline_prompt_cyan('Upgrade Web App Services')

      Orchestrator::Terraform::Fetch.specific_state_output('ecr_web', true)
      Orchestrator::Terraform::Cli.terraform_tfvars_command_path('apply -auto-approve -parallelism=20 -refresh=true -compact-warnings', 'ecr_web')

      end_time = Time.now
      run_time = Orchestrator::ConsoleOutputs.time_diff(start_time, end_time)
      Orchestrator::ConsoleOutputs.footer(run_time)
      Rake::Task['bonusbits:info:summary'].execute
    end
  end
end

desc 'Alias (bonusbits:upgrade:stack)'
task upgrade: %w[bonusbits:upgrade:stack]
