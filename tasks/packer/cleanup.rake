namespace :packer do
  namespace :cleanup do
    desc 'Remove Old Images'
    task :remove_old_images, [:instance_name, :ami_save_count] do |_task, args|
      Orchestrator::ConsoleOutputs.header
      search_string = "#{$project_vars['packer']['image_name_prepend']}_#{args[:instance_name]}_2*"
      region_list = $project_vars['packer']['region_list']
      region_list.each do |region|
        Orchestrator::ConsoleOutputs.sub_header_item('Remove Old Images', "#{args[:instance_name]}/#{region}")
        Orchestrator::ConsoleOutputs.debug_message_item('Save AMI Count', args[:ami_save_count])
        image_ids = Orchestrator::AWS::EC2.old_ami_ids(args[:instance_name], search_string, args[:ami_save_count], region)
        Orchestrator::ConsoleOutputs.message_item('Image IDs to Remove', image_ids.count)
        Orchestrator::ConsoleOutputs.debug_message_item('Image IDs', image_ids)
        image_ids.each do |ami_id|
          Orchestrator::AWS::EC2.remove_image(ami_id, region)
        end
      end
    end
  end
end

desc 'Alias (packer:cleanup:remove_old_images[name,ami_save_count]) - rake pkr_cleanup[bastion,2]'
task :pkr_cleanup, [:image, :ami_save_count] do |_task, args|
  Rake::Task['packer:cleanup:remove_old_images'].invoke(args[:image], args[:ami_save_count])
end
