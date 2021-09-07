namespace :bonusbits do
  namespace :destroy do
    desc 'Delete Entire Stack with Terraform (Based on Env Vars)'
    task :stack do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.press_any_key(true, 'Terraform Destroy')
      start_time = Time.now
      Rake::Task['terraform:destroy'].execute
      end_time = Time.now
      run_time = Orchestrator::ConsoleOutputs.time_diff(start_time, end_time)
      Orchestrator::ConsoleOutputs.footer(run_time)
    end
  end
end

desc 'Alias (bonusbits:destroy:stack)'
task down: %w[bonusbits:destroy:stack]
