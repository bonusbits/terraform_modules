namespace :demo do
  namespace :deploy do
    desc 'Create Entire Stack with Terraform (Based on Env Vars)'
    task :stack do
      require 'highline/import'

      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.press_any_key(true, 'Keys, Init & Apply')
      start_time = Time.now

      skip_all_prompts = $project_vars['orchestrator']['feature_toggles']['skip_all_prompts'].nil? ? false : $project_vars['orchestrator']['feature_toggles']['skip_all_prompts']
      Orchestrator::ConsoleOutputs.warning_sub_header('Rake Var Set (Skip All Prompts)') if skip_all_prompts

      Rake::Task['bastion:secrets:create_ssh_key'].execute
      Rake::Task['terraform:init'].execute if skip_all_prompts || Orchestrator::ConsoleOutputs.highline_prompt_yellow('Run Init')

      # Not passing a role runs them all
      # Rake::Task['terraform:apply'].execute

      $project_vars['terraform']['roles'].each do |role|
        Orchestrator::ConsoleOutputs.sub_header_item('Terraform Apply', role)
        next unless skip_all_prompts || HighLine.agree("Continue with #{role}? (#{'y/n'.colorize(:light_yellow)}) ")

        Orchestrator::Terraform::Cli.command_tfvars('refresh', 'Terraform Refresh', role) if role =~ /eks.*/ || role == 'app_containers'
        Orchestrator::Terraform::Cli.terraform_tfvars_command_path('apply -auto-approve -parallelism=20 -refresh=true -compact-warnings', role)

        # Setup Roles
        case role
        when 'bastion'
          next unless skip_all_prompts || Orchestrator::ConsoleOutputs.highline_prompt_yellow('Setup Bastion')

          Orchestrator::ConsoleOutputs.debug_message('demo:deploy:stack - setup cased to bastion')
          Rake::Task['bastion:setup:instance'].execute
        end
      end

      end_time = Time.now
      run_time = Orchestrator::ConsoleOutputs.time_diff(start_time, end_time)
      Orchestrator::ConsoleOutputs.footer(run_time)
      Rake::Task['demo:info:summary'].execute
    end
  end
end

desc 'Alias (demo:deploy:stack)'
task demo_up: %w[demo:deploy:stack]
