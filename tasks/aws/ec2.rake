namespace :aws do
  namespace :ec2 do
    desc 'Get Latest AMI ID - rake aws:ec2:latest_ami_id[bastion]'
    task :latest_ami_id, [:name] do |_task, args|
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header_item('Get Latest AMI ID', args[:name])
      image_id = Orchestrator::AWS::EC2.latest_ami_id(args[:name])
      Orchestrator::ConsoleOutputs.message_item('Latest Image ID', image_id)
    end

    desc 'Remove Single Specific Instance Name Old Images'
    task :remove_old_instance_images, [:instance_name, :ami_save_count] do |_task, args|
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header_item('Remove Old Images', args[:instance_name])
      search_string = "#{$project_vars['terraform']['workspace']}-#{args[:instance_name].sub('_', '-')}-2*"
      image_ids = Orchestrator::AWS::EC2.old_ami_ids(args[:instance_name], search_string, args[:ami_save_count])
      Orchestrator::ConsoleOutputs.debug_message_item('Image IDs', image_ids)
      image_ids.each do |ami_id|
        Orchestrator::ConsoleOutputs.message_item('Removing', ami_id)
        Orchestrator::AWS::EC2.remove_image(ami_id)
      end
    end
  end
end
