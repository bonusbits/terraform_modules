namespace :bonusbits do
  namespace :info do
    desc 'Display Stack Summary'
    task :summary do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::BonusBits::Info.summary
    end
  end
end

desc 'Alias (bonusbits:info:summary)'
task bb_info: %w[bonusbits:info:summary]
