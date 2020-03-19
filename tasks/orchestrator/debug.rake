# All Tasks that really are only used for debugging or validating Orchestrator and Terraform.
namespace :orchestrator do
  namespace :debug do
    desc 'Display Current Environment'
    task :env do
      Orchestrator::ConsoleOutputs.environment
    end

    # No header so works on various roles
    desc 'Display Orchestrator Version'
    task :orchestrator_version do
      version = Orchestrator::Vars.orchestrator_version
      Orchestrator::ConsoleOutputs.message_item('Orchestrator', "v#{version}")
    end

    desc 'Show Project Rake Variables from Yaml and Environment Variables'
    task :show_vars do
      Orchestrator::Vars.show_vars
    end
  end
end

desc 'Alias (orchestrator:debug:env)'
task env: %w[orchestrator:debug:env]

desc 'Alias (orchestrator:debug:show_vars)'
task show_vars: %w[orchestrator:debug:show_vars]
