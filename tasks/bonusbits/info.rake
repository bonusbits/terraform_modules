namespace :bonusbits do
  namespace :info do
    desc 'Display Network Info'
    task :network do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::BonusBits::Info.network
    end

    desc 'Display Stack Summary'
    task :summary do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::BonusBits::Info.summary
    end
  end
end

desc 'Alias (bonusbits:info:network)'
task info_network: %w[bonusbits:info:network]

desc 'Alias (bonusbits:info:summary)'
task info: %w[bonusbits:info:summary]
