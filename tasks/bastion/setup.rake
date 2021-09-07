namespace :bastion do
  namespace :setup do
    desc 'Setup Bastion Instance'
    task :instance do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header('Setup Bastion Instance')
      start_time = Time.now

      # Wait for Instance to be Ready
      Rake::Task['bastion:tests:instance_status_loop'].execute

      # Watch Tail Cloud Init to Complete
      Rake::Task['bastion:tests:tail_cloud_init_loop'].execute

      # Users
      # Rake::Task['bastion:users:add'].execute

      end_time = Time.now
      run_time = Orchestrator::ConsoleOutputs.time_diff(start_time, end_time)
      Orchestrator::ConsoleOutputs.footer(run_time)
    end
  end
end

desc 'Alias (bastion:setup:instance)'
task setup_bastion: %w[bastion:setup:instance]
