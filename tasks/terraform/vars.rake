namespace :terraform do
  namespace :vars do
    desc 'Create Import Maps Folder Locally'
    task :create_import_maps_folder do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header_item('Creating Import Maps Folder', $project_vars['terraform']['workspace'])
      Orchestrator::Terraform::Vars.create_import_maps_folder
    end

    # No header so works on various roles ??
    desc 'Display Local Terraform Version'
    task :local_version do
      Orchestrator::ConsoleOutputs.sub_header('Local Terraform Version')
      version = Orchestrator::Terraform::Vars.local_version
      Orchestrator::ConsoleOutputs.message_item('Terraform', "v#{version}")
    end
  end
end
