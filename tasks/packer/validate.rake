namespace :packer do
  desc 'Run Packer Validate - (rake packer:validate[ubuntu_1804,bastion])'
  task :validate, [:image, :role] do |_task, args|
    Orchestrator::Packer::Cli.command_chdir('validate', 'Packer Validate', args[:image], args[:role])
  end
end

desc 'Alias (packer:validate[image,role]) - rake pkr_validate[ubuntu_1804,bastion]'
task :pkr_validate, [:image, :role] do |_task, args|
  Rake::Task['packer:validate'].invoke(args[:image], args[:role])
end
