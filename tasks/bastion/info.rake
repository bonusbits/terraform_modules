namespace :bastion do
  namespace :info do
    desc 'Display Bastion Summary'
    task :summary do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::Bastion::Info.summary
    end
  end
end

desc 'Alias (bastion:info:summary)'
task info_bastion: %w[bastion:info:summary]
