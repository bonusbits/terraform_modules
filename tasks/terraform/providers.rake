namespace :terraform do
  namespace :providers do
    desc 'Display Terraform Providers - (rake terraform:providers[role])'
    task :list, [:role] do |_task, args|
      Orchestrator::ConsoleOutputs.header
      Orchestrator::Terraform::Cli.command('providers', 'Terraform Providers', args[:role])
    end

    desc 'Delete Providers in a Role - (rake terraform:providers:delete_role_cache, rake terraform:providers:delete_role_cache[role])'
    task :delete_role_cache, [:role] do |_task, args|
      args.with_defaults(role: nil)
      Orchestrator::ConsoleOutputs.header
      if args[:role].nil?
        $project_vars['terraform']['roles'].each do |role|
          Orchestrator::ConsoleOutputs.sub_header_item('Delete Providers', role)
          Orchestrator::Terraform::Providers.delete_role_cache(role)
        end
      else
        Orchestrator::ConsoleOutputs.sub_header_item('Delete Providers', args[:role])
        Orchestrator::Terraform::Providers.delete_role_cache(args[:role])
      end
    end

    desc 'Delete Providers Caches in all Roles and Global - (rake terraform:providers:delete_all_cache)'
    task :delete_all_caches do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header('Delete Providers Caches in all Roles and Global')
      Rake::Task['terraform:providers:delete_role_cache'].execute
      Rake::Task['terraform:providers:delete_global_cache'].execute
    end

    desc 'Delete Providers in Global Cache - (rake terraform:providers:delete_global_cache, rake terraform:providers:delete_global_cache[path])'
    task :delete_global_cache, [:path] do |_task, args|
      args.with_defaults(path: $project_vars['terraform']['plugin_cache_dir'])
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header_item('Delete All Terraform Providers in Global Cache', args[:path])
      Orchestrator::Terraform::Providers.delete_global_cache(args[:path])
    end
  end
end
