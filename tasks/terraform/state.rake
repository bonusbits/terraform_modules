namespace :terraform do
  namespace :state do
    desc 'Terraform State List - (rake terraform:state:list[role])'
    task :list, [:role] do |_task, args|
      args.with_defaults(role: nil)
      Orchestrator::ConsoleOutputs.header
      if args[:role].nil?
        $project_vars['terraform']['roles'].each do |role|
          Orchestrator::ConsoleOutputs.sub_header_item('Terraform State List', role)
          Orchestrator::Terraform::Cli.terraform_command_path('state list', role)
        end
      else
        Orchestrator::ConsoleOutputs.sub_header_item('Terraform State List', args[:role])
        Orchestrator::Terraform::Cli.terraform_command_path('state list', args[:role])
      end
    end

    desc 'Terraform State Move - (rake terraform:state:move[role,source,destination])'
    task :move, [:role, :source, :destination] do |_task, args|
      skip_all_prompts = $project_vars['orchestrator']['feature_toggles']['skip_all_prompts'].nil? ? false : $project_vars['orchestrator']['feature_toggles']['skip_all_prompts']
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header_item('Terraform State Move', "#{args[:role]}/#{args[:source]} >> #{args[:destination]}")
      next unless skip_all_prompts || Orchestrator::ConsoleOutputs.highline_prompt_yellow('Move State Binding')

      Orchestrator::Terraform::Cli.terraform_command_path('state mv', args[:role], args[:source], args[:destination])
    end

    desc 'Terraform State Remove - (rake terraform:state:remove[role,address])'
    task :remove, [:role, :address] do |_task, args|
      skip_all_prompts = $project_vars['orchestrator']['feature_toggles']['skip_all_prompts'].nil? ? false : $project_vars['orchestrator']['feature_toggles']['skip_all_prompts']
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header_item('Terraform State Remove', "#{args[:role]}/#{args[:address]}")
      next unless skip_all_prompts || Orchestrator::ConsoleOutputs.highline_prompt_yellow('Remove State Binding')

      Orchestrator::Terraform::Cli.terraform_command_path('state rm', args[:role], args[:address])
    end
  end
end

desc 'Alias (terraform:state:list[role])'
task :state_list, [:role] do |_task, args|
  args.with_defaults(role: nil)
  Rake::Task['terraform:state:list'].invoke(args[:role])
end

desc 'Alias (terraform:state:move[role,source,destination])'
task :state_move, [:role, :source, :destination] do |_task, args|
  Rake::Task['terraform:state:move'].invoke(args[:role], args[:source], args[:destination])
end

desc 'Alias (terraform:state:remove[role,address])'
task :state_remove, [:role, :address] do |_task, args|
  Rake::Task['terraform:state:remove'].invoke(args[:role], args[:address])
end
