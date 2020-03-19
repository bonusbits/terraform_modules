namespace :terraform do
  desc 'Run Terraform Import - (rake terraform:import, rake terraform:import[role], rake terraform:import[role,filename])'
  task :import, [:role, :filename] do |_task, args|
    Orchestrator::ConsoleOutputs.header
    skip_all_prompts = $project_vars['orchestrator']['feature_toggles']['skip_all_prompts'].nil? ? false : $project_vars['orchestrator']['feature_toggles']['skip_all_prompts']

    start_time = Time.now

    if args[:role].nil?
      # Run Through All Role Items in Vars
      ## i.e. ["network", "cloudwatch_logs", "bastion", "efs", "rds_mysql", "ecr_web"]
      ## Assume that import map files are named matching role
      ## i.e. network.yml, cloudwatch_logs.yml
      Orchestrator::ConsoleOutputs.sub_header('Import All Terraform Resources')
      Orchestrator::Terraform::Vars.load_import_maps
      $project_vars['terraform']['roles'].each do |role|
        Orchestrator::ConsoleOutputs.sub_header_item('Terraform Import', role)
        if $import_vars[role].nil?
          Orchestrator::ConsoleOutputs.error_message_item('Import Map Missing', role)
        else
          next unless skip_all_prompts || Orchestrator::ConsoleOutputs.highline_prompt_yellow("Continue with #{role}")

          Dir.chdir("#{$project_vars['orchestrator']['orchestrator_path']}/terraform/environments/#{$project_vars['orchestrator']['environment']}/#{role}") do
            $import_vars[role].each do |key, value|
              Orchestrator::ConsoleOutputs.sub_header(key.to_s)
              Orchestrator::Terraform::Cli.terraform_tfvars_command('import', role, key, value)
            end
            end_time = Time.now
            run_time = Orchestrator::ConsoleOutputs.time_diff(start_time, end_time)
            Orchestrator::ConsoleOutputs.role_footer(role, run_time)
          end
        end
      end
    elsif args[:filename].nil?
      # Only Item arg passed so assume the import map is named the same as the role
      ## i.e. bastion.yml, network.yml
      Orchestrator::ConsoleOutputs.sub_header_item('Import Terraform Resources', args[:role])
      role = args[:role]
      Orchestrator::Terraform::Vars.load_import_maps
      Dir.chdir("#{$project_vars['orchestrator']['orchestrator_path']}/terraform/environments/#{$project_vars['orchestrator']['environment']}/#{role}") do
        $import_vars[role].each do |key, value|
          Orchestrator::Terraform::Cli.terraform_tfvars_command('import', role, key, value)
        end
        end_time = Time.now
        run_time = Orchestrator::ConsoleOutputs.time_diff(start_time, end_time)
        Orchestrator::ConsoleOutputs.role_footer(args[:role], run_time)
      end
    else
      # Assumes args item and filename passed
      ## This is the most flexible option. Name the role item and the name of the import map yaml minus the extension
      import_map = Orchestrator::Vars.load_import_map(args[:filename])
      role = args[:role]
      Orchestrator::ConsoleOutputs.sub_header_item('Import Terraform Resources', "#{role}/#{args[:filename]}.yml")

      start_time = Time.now
      Dir.chdir("#{$project_vars['orchestrator']['orchestrator_path']}/terraform/environments/#{$project_vars['orchestrator']['environment']}/#{role}") do
        import_map.each do |key, value|
          Orchestrator::Terraform::Cli.terraform_tfvars_command('import', role, key, value)
        end
        end_time = Time.now
        run_time = Orchestrator::ConsoleOutputs.time_diff(start_time, end_time)
        Orchestrator::ConsoleOutputs.role_footer(args[:role], run_time)
      end
    end
  end
end

desc 'Alias (terraform:import[role,filename])'
task :import, [:role, :filename] do |_task, args|
  Rake::Task['terraform:import'].invoke(args[:role], args[:filename])
end
