namespace :bastion do
  namespace :ec2 do
    desc 'Create Bastion Instance Image'
    task :create_ami do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header('Create Bastion Instance Image')
      Orchestrator::Bastion::EC2.create_ami
    end

    desc 'Remove Old Bastion Images'
    task :remove_old_ami, [:ami_save_count] do |_task, args|
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header_item('Remove Old Bastion Images and Save Count', args[:ami_save_count])

      instance_name = 'bastion'
      search_string = "#{$project_vars['terraform']['workspace']}-#{instance_name}-2*"

      image_ids = Orchestrator::AWS::EC2.old_ami_ids(instance_name, search_string, args[:ami_save_count])
      Orchestrator::ConsoleOutputs.debug_message_item('Image IDs', image_ids)
      image_ids.each do |ami_id|
        Orchestrator::ConsoleOutputs.message_item('Removing AMI ID', ami_id)
        Orchestrator::AWS::EC2.remove_image(ami_id)
      end
    end

    desc 'Stop Bastion Instances'
    task :stop_instance do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header('Stopping Bastion Instance')
      Orchestrator::Bastion::EC2.stop_instance
    end

    desc 'Start Bastion Instances'
    task :start_instance do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header('Start Bastion Instance')
      Orchestrator::Bastion::EC2.start_instance
    end
  end
end

desc 'Alias (bastion:ec2:create_ami)'
task create_ami_bastion: %w[bastion:ec2:create_ami]

desc 'Alias (bastion:ec2:start_instance)'
task start_bastion: %w[bastion:ec2:start_instance]

desc 'Alias (bastion:ec2:stop_instance)'
task stop_bastion: %w[bastion:ec2:stop_instance]
