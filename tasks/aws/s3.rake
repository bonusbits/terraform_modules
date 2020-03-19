namespace :aws do
  namespace :s3 do
    desc 'Download all Terraform State Files from S3'
    task :download_state_files, [:force] do |_task, args|
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header('Download Terraform State Files from S3')

      force_download = if args[:force].nil?
                         false
                       else
                         args[:force] == 'true'
                       end
      Orchestrator::AWS::S3.download(force_download)
    end

    desc 'Upload a Single Terraform State File to S3 - (rake aws:s3:upload_state_file[bastion])'
    task :upload_state_file, [:role] do |_task, args|
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header_item('Upload Terraform State Files to S3', args[:role])
      Orchestrator::AWS::S3.upload(args[:role])
    end

    desc 'Upload all Terraform State File to S3'
    task :upload_all_state_files do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header('Upload All Terraform State Files from S3')
      Orchestrator::AWS::S3.upload_all
    end
  end
end

desc 'Alias (aws:s3:download_state_files[force])'
task :s3d, [:force] do |_task, args|
  Rake::Task['aws:s3:download_state_files'].invoke(args[:force])
end

desc 'Alias (aws:s3:download_state_files[force])'
task :s3download, [:force] do |_task, args|
  Rake::Task['aws:s3:download_state_files'].invoke(args[:force])
end

desc 'Alias (aws:s3:upload_state_file[item])'
task :s3u, [:role] do |_task, args|
  Rake::Task['aws:s3:upload_state_file'].invoke(args[:role])
end

desc 'Alias (aws:s3:upload_state_file[item])'
task :s3upload, [:role] do |_task, args|
  Rake::Task['aws:s3:upload_state_file'].invoke(args[:role])
end
