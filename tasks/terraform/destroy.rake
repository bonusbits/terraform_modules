namespace :terraform do
  desc 'Run Terraform Destroy - (rake terraform:destroy, rake terraform:destroy[bastion])'
  task :destroy, [:role] do |_task, args|
    Orchestrator::ConsoleOutputs.header

    skip_all_prompts = $project_vars['orchestrator']['feature_toggles']['skip_all_prompts'].nil? ? false : $project_vars['orchestrator']['feature_toggles']['skip_all_prompts']

    Orchestrator::ConsoleOutputs.warning_sub_header('Rake Var Set (Skip Terraform Destroy Prompts)') if skip_all_prompts

    if args[:role].nil?
      if skip_all_prompts
        Orchestrator::ConsoleOutputs.exclamation_sub_header('Are you Sure? This will Destroy the Entire Stack!')
        Orchestrator::ConsoleOutputs.press_any_key
      end
      $project_vars['terraform']['roles'].reverse_each do |role|
        Orchestrator::ConsoleOutputs.sub_header_item('Terraform Destroy', role)
        next unless skip_all_prompts || Orchestrator::ConsoleOutputs.highline_prompt_red("Continue with #{role}")

        start_time = Time.now
        Orchestrator::Terraform::Cli.command_tfvars('refresh', 'Terraform Refresh', role) if role =~ /eks.*/
        Orchestrator::Terraform::Cli.terraform_tfvars_command_path('destroy -auto-approve', role)
        end_time = Time.now
        run_time = Orchestrator::ConsoleOutputs.time_diff(start_time, end_time)
        Orchestrator::ConsoleOutputs.role_footer(role, run_time)
      end
    else
      if skip_all_prompts
        Orchestrator::ConsoleOutputs.exclamation_sub_header('Are you Sure? This will Destroy the Role!')
        Orchestrator::ConsoleOutputs.press_any_key
      end
      Orchestrator::Terraform::Cli.command_tfvars('refresh', 'Terraform Refresh', args[:role]) if args[:role] =~ /eks.*/
      Orchestrator::ConsoleOutputs.sub_header_item('Terraform Destroy Role', args[:role])
      Orchestrator::Terraform::Cli.terraform_tfvars_command_path('destroy -auto-approve', args[:role])
    end
  end

  desc 'Destroy Terraform Resource Target - (rake terraform:destroy_target[eks,module.eks_node_group.aws_eks_node_group.default])'
  task :destroy_target, [:role, :target] do |_task, args|
    Orchestrator::ConsoleOutputs.header
    Orchestrator::ConsoleOutputs.sub_header_item('Terraform Destroy Target', args[:target])
    Orchestrator::Terraform::Cli.terraform_tfvars_command_path('destroy', args[:role], "-target=#{args[:target]}")
  end
end

desc 'Alias (terraform:destroy[role])'
task :destroy, [:role] do |_task, args|
  Rake::Task['terraform:destroy'].invoke(args[:role])
end

desc 'Alias (terraform:destroy_target[role,target])'
task :destroy_target, [:role, :target] do |_task, args|
  Rake::Task['terraform:destroy_target'].invoke(args[:role], args[:target])
end
