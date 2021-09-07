namespace :bastion do
  namespace :users do
    desc 'Add Users to Bastion Host'
    task :add do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header('Add Users to Bastion Host')
      Orchestrator::Bastion.add_users
    end
  end
end
