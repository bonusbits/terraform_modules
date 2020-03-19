namespace :packer do
  namespace :build do
    desc 'Packer Build AMI (rake packer:build:ami[ubuntu_1804,backend])'
    task :ami, [:image, :role] do |_task, args|
      image = args[:image]
      role = args[:role]
      Orchestrator::Packer::Cli.command_chdir('build', 'Packer Build', image, role)
    end
  end
end

desc 'Alias (packer:build:ami[image,role]) - rake pkr_build[ubuntu_1804,web]'
task :pkr_build, [:image, :role] do |_task, args|
  Rake::Task['packer:build:ami'].invoke(args[:image], args[:role])
end
