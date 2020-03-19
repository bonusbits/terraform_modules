namespace :packer do
  namespace :vars do
    desc 'Display Local Packer Version'
    task :local_version do
      Orchestrator::ConsoleOutputs.sub_header('Local Packer Version')
      version = Orchestrator::Packer::Vars.local_version
      Orchestrator::ConsoleOutputs.message_item('Packer', "v#{version}")
    end
  end
end
