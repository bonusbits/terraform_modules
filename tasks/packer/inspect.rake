namespace :packer do
  desc 'Run Packer Inspect - (rake packer:inspect[ubuntu_1804,bastion])'
  task :inspect, [:image, :role] do |_task, args|
    Orchestrator::Packer::Cli.command_chdir('inspect', 'Packer Inspect', args[:image], args[:role])
  end
end

desc 'Alias (packer:inspect[image,role]) - rake pkr_inspect[ubuntu_1804,bastion]'
task :pkr_inspect, [:image, :role] do |_task, args|
  Rake::Task['packer:inspect'].invoke(args[:image], args[:role])
end
