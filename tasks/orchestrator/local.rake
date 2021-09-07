# Tasks Specific to Local Setup
namespace :orchestrator do
  namespace :local do
    desc 'Display Relevant Local Environment Variables'
    task :show_local_env_vars do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header('Relevant Local Environment Variables')
      Orchestrator::Local.show_local_env_vars
    end

    desc 'Display Local Tool Versions'
    task :show_local_versions do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header('Local Tool Versions')
      Orchestrator::Local.show_local_versions
    end
  end
end

desc 'Alias (orchestrator:local:show_local_versions)'
task local_versions: %w[orchestrator:local:show_local_versions]

desc 'Alias (orchestrator:local:show_local_versions)'
task local_env: %w[orchestrator:local:show_local_versions orchestrator:local:show_local_env_vars]
