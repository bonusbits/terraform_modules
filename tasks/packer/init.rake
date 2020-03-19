namespace :packer do
  desc 'Run Packer Initialization - (rake packer:init[ubuntu_1804,backend])'
  task :init, [:image, :role] do |_task, args|
    Orchestrator::Packer::Cli.command_chdir('init', 'Packer Initialization', args[:image], args[:role])
  end
end

desc 'Alias (packer:init[image,role]) - rake pkr_init[ubuntu_1804,bastion]'
task :pkr_init, [:image, :role] do |_task, args|
  Rake::Task['packer:init'].invoke(args[:image], args[:role])
end
