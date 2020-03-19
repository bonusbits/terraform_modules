module Orchestrator
  module AWS
    module EC2
      def self.ec2_client(region = $project_vars['aws']['region'], profile = $project_vars['aws']['profile'])
        require 'aws-sdk-ec2'

        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.ec2_client] region', region)
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.ec2_client] profile', profile)

        Aws::EC2::Client.new(
          region: region,
          profile: profile
        )
        # require 'aws-sdk-ec2'
        # ec2_client = Aws::EC2::Client.new(region: 'us-west-2', profile: 'bonusbits')
      end

      def self.ec2_resource(region = $project_vars['aws']['region'], profile = $project_vars['aws']['profile'])
        require 'aws-sdk-ec2'

        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.ec2_resource] region', region)
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.ec2_resource] profile', profile)

        Aws::EC2::Resource.new(
          region: region,
          profile: profile
        )
        # require 'aws-sdk-ec2'
        # ec2_resource = Aws::EC2::Resource.new(region: 'us-west-2', profile: 'bonusbits')
      end

      def self.instance_private_ip(instance_id)
        ec2_client = Orchestrator::AWS::EC2.ec2_client
        begin
          retries ||= 0
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.instance_private_ip] retries', retries)
          instance_private_ip = ec2_client.describe_instances(instance_ids: [instance_id.to_s]).data[0][0].instances[0].private_ip_address
        rescue StandardError => e
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.instance_private_ip]  Standard Error Output', e)
          Orchestrator::ConsoleOutputs.error_message_item('[Orchestrator::AWS::EC2.instance_private_ip] - Rescue', retries)
          sleep 1
          retry if (retries += 1) < 10
        end
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.instance_private_ip] IP Address', instance_private_ip)
        instance_private_ip
      end

      def self.check_image_status(ami_id)
        ec2_client = Orchestrator::AWS::EC2.ec2_client
        begin
          retries ||= 0
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.check_image_status] retries', retries)
          describe_image_response = ec2_client.describe_images(image_ids: [ami_id])
        rescue StandardError => e
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.check_image_status]  Standard Error Output', e)
          Orchestrator::ConsoleOutputs.error_message_item('[Orchestrator::AWS::EC2.check_image_status] - Rescue', retries)
          sleep 1
          retry if (retries += 1) < 10
        end
        results = describe_image_response.images[0].state
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.check_image_status] Return', results)
        results
      end

      def self.check_image_status_loop(ami_id)
        loop_count = 0
        image_status = 'UNKNOWN'
        print 'Checking Status '
        # Loop for 1080 Intervals at 5 seconds each (60 minutes) Max checking if AMI is available
        until loop_count >= 1080 || image_status == 'available'
          loop_count += 1
          print '.'
          image_status = Orchestrator::AWS::EC2.check_image_status(ami_id)
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.check_image_status_loop] Loops Count', loop_count)
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.check_image_status_loop] Image Status', image_status)
          sleep 5 unless image_status == 'available'
        end

        puts ''
        if image_status == 'available'
          Orchestrator::ConsoleOutputs.info_message_item('Image Status', "#{ami_id}: #{image_status}")
          true
        else
          Orchestrator::ConsoleOutputs.error_message_item('[Orchestrator::AWS::EC2.check_image_status_loop] Image Status', image_status)
          false
        end
      end

      def self.check_instance_status(instance_id)
        results = Hash.new
        ec2_client = Orchestrator::AWS::EC2.ec2_client
        begin
          retries ||= 0
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.check_instance_status] retries', retries)
          ec2_status_response = ec2_client.describe_instance_status(instance_ids: [instance_id])
        rescue StandardError => e
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.check_instance_status]  Standard Error Output', e)
          Orchestrator::ConsoleOutputs.error_message_item('[Orchestrator::AWS::EC2.check_instance_status] - Rescue', retries)
          sleep 1
          retry if (retries += 1) < 10
        end
        results['instance'] = ec2_status_response.instance_statuses[0].instance_status.status
        results['system'] = ec2_status_response.instance_statuses[0].system_status.status
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.check_instance_status] Return', results)
        results
      end

      def self.check_instance_status_loop(instance_id)
        loop_count = 0
        results = Hash.new
        results['instance'] = nil
        results['system'] = nil
        print 'Checking Status '
        until loop_count >= 180 || results['instance'] == 'ok' && results['system'] == 'ok'
          loop_count += 1
          print '.'
          results = Orchestrator::AWS::EC2.check_instance_status(instance_id)
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.check_instance_status_loop] EC2 Instance Status', results['instance'])
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.check_instance_status_loop] EC2 System Status', results['system'])
          sleep 5 unless results['instance'] == 'ok' && results['system'] == 'ok'
        end

        puts ''
        if results['instance'] == 'ok' && results['system'] == 'ok'
          Orchestrator::ConsoleOutputs.info_message_item('ECS Instance Status OK', instance_id)
          true
        else
          Orchestrator::ConsoleOutputs.error_message_item('[Orchestrator::AWS::EC2.check_instance_status_loop] ECS Instance Status NOT OK', instance_id)
          false
        end
      end

      def self.create_image_command(instance_id, image_name, description)
        ec2_client = Orchestrator::AWS::EC2.ec2_client
        begin
          retries ||= 0
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.create_image_command] retries', retries)
          ec2_client.create_image(
            dry_run: false,
            name: image_name, # required
            description: description,
            no_reboot: true,
            instance_id: instance_id
            # block_device_mappings: [
            #     {
            #         virtual_name: "String",
            #         device_name: "String",
            #         ebs: {
            #             snapshot_id: "String",
            #             volume_size: 1,
            #             delete_on_termination: false,
            #             volume_type: "standard", # accepts standard, io1, gp2, sc1, st1
            #             iops: 1,
            #             encrypted: false,
            #         },
            #         no_device: "String",
            #     },
            # ],
          )
        rescue StandardError => e
          Orchestrator::ConsoleOutputs.error_message_item('[Orchestrator::AWS::EC2.create_image_command] - Rescue', retries)
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.create_image_command]  Standard Error Output', e)
          sleep 1
          retry if (retries += 1) < 10
          return false
        end
        true
      end

      # i.e. Orchestrator::AWS::EC2.create_ami('bastion', i-0e8eee206aa32a09e)
      def self.create_ami(name, instance_id, skip_status = false, image_name = "#{$project_vars['terraform']['workspace']}-#{name}-#{Time.now.strftime('%Y%m%d%H%M')}")
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.create_ami] image_name', image_name)

        orchestrator_version = Orchestrator::Vars.orchestrator_version
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.create_ami] orchestrator_version', orchestrator_version)

        description = "Created by Orchestrator v#{orchestrator_version}"
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.create_ami] description', description)

        success = Orchestrator::AWS::EC2.create_image_command(instance_id, image_name, description)
        if success
          Orchestrator::ConsoleOutputs.info_message_item('Image Created', image_name)
        else
          Orchestrator::ConsoleOutputs.error_message_item('[Orchestrator::AWS::EC2.create_ami]  Standard Error Output', image_name)
        end

        return if skip_status

        images_id = Orchestrator::AWS::EC2.latest_ami_id(name)
        Orchestrator::ConsoleOutputs.sub_header_item('Image Status', name)
        image_status_available = Orchestrator::AWS::EC2.check_image_status_loop(images_id)
        raise Orchestrator::ConsoleOutputs.error_message_item('Image Status Not OK', image_status_available) unless image_status_available
      end

      def self.latest_ami_id(name, search_string = "#{$project_vars['terraform']['workspace']}-#{name.sub('_', '-')}-2*")
        ec2_client = Orchestrator::AWS::EC2.ec2_client
        aws_account_id = Orchestrator::AWS::Iam.current_user_account_id
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.latest_ami_id] Fetching Image ID', name)
        begin
          retries ||= 0
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.latest_ami_id] retries', retries)
          all_instance_images = ec2_client.describe_images(owners: [aws_account_id], filters: [{ name: 'name', values: [search_string] }])
        rescue StandardError => e
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.latest_ami_id] Standard Error Output', e)
          Orchestrator::ConsoleOutputs.error_message_item('[Orchestrator::AWS::EC2.latest_ami_id] - Rescue', retries)
          sleep 1
          retry if (retries += 1) < 10
        end
        # Sort Array of Hashes Responses by AMI Name so newest is the last element in the array then return the image_id value
        return 'NO IMAGE FOUND' if all_instance_images.images.empty?

        all_instance_images.images.max_by { |k| k['name'] }.image_id
      end

      def self.old_ami_ids(instance_name, search_string, ami_save_count = 2, region = $project_vars['aws']['region'])
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.old_ami_ids] instance_name', instance_name)
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.old_ami_ids] search_string', search_string)
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.old_ami_ids] ami_save_count', ami_save_count)
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.old_ami_ids] region', region)

        ec2_client = Orchestrator::AWS::EC2.ec2_client(region)
        aws_account_id = Orchestrator::AWS::Iam.current_user_account_id

        # Fetch AMI Objects from AWS based on Search String
        begin
          retries ||= 0
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.old_ami_ids] retries', retries)

          # Fetch All Images for the workspace and Instance Name
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.old_ami_ids] Search String', search_string)
          all_instance_images = ec2_client.describe_images(owners: [aws_account_id], filters: [{ name: 'name', values: [search_string] }])
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.old_ami_ids] all_instance_images.count', all_instance_images.images.count)
        rescue StandardError => e
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.old_ami_ids] Standard Error Output', e)

          Orchestrator::ConsoleOutputs.error_message_item('[Orchestrator::AWS::EC2.old_ami_ids] - Rescue', retries)
          sleep 1

          retry if (retries += 1) < 10
        end

        # Create Hash of Image Name and Image IDs
        name_id_list = Hash.new
        all_instance_images.images.each do |key|
          name_id_list[key['name']] = key['image_id']
        end
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.old_ami_ids] name_id_list', name_id_list)
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.old_ami_ids] name_id_list.count', name_id_list.count)

        # Sort Hash Keys Oldest to Newest
        sorted_id_list = name_id_list.sort.to_h
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.old_ami_ids] sorted_id_list', sorted_id_list)
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.old_ami_ids] sorted_id_list.count', sorted_id_list.count)

        # Remove Newest AMIs from end of sorted list
        ami_save_count = ami_save_count.to_i
        until ami_save_count <= 0
          remove_key = sorted_id_list.keys.last
          sorted_id_list.delete(remove_key)
          ami_save_count -= 1
        end
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.old_ami_ids] Sorted Image ID List', sorted_id_list)
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.old_ami_ids] sorted_id_list.count', sorted_id_list.count)

        # Pull Image IDs into an Array to Return
        image_ids = Array.new
        sorted_id_list.each do |_k, v|
          image_ids << v
        end
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.old_ami_ids] return: image_ids', image_ids)
        image_ids
      end

      def self.remove_image(ami_id, region = $project_vars['aws']['region'], profile = $project_vars['aws']['profile'])
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.remove_image] Removing', ami_id)
        ec2_client = Orchestrator::AWS::EC2.ec2_client(region, profile)
        begin
          retries ||= 0
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.remove_image] retries', retries)
          deregister_response = ec2_client.deregister_image(image_id: ami_id)
          success = deregister_response.successful?
        rescue Aws::EC2::Errors::InvalidAMIIDUnavailable
          Orchestrator::ConsoleOutputs.error_message_item('[Orchestrator::AWS::EC2.remove_image] Invalid AMI ID', ami_id)
          success = false
        rescue StandardError => e
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.remove_image] Standard Error Output', e)
          Orchestrator::ConsoleOutputs.error_message_item('[Orchestrator::AWS::EC2.remove_image] - Rescue', retries)
          sleep 1
          retry if (retries += 1) < 10
        end
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.remove_image] successful?', success)
        success
      end

      # Orchestrator::AWS::EC2.start_stop_status_loop('i-0e8eee805aa32a09e', 'start')
      def self.start_stop_status_loop(instance_id, desired_state)
        case desired_state
        when 'start'
          desired_state_code = 16
        when 'stop'
          desired_state_code = 80
        else
          raise Orchestrator::ConsoleOutputs.error_message_item('Desired State Can only be start or stop', desired_state)
        end
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.start_stop_status_loop] desired_state_code', desired_state_code)

        ec2_resource = Orchestrator::AWS::EC2.ec2_resource

        loop_count = 0
        until loop_count >= 600 || ec2_resource.instance(instance_id).state.code == desired_state_code
          loop_count += 1
          print '.'
          state_code = ec2_resource.instance(instance_id).state.code
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.start_stop_status_loop] Status', state_code)
          status_stopped = state_code == desired_state_code
          sleep 1 unless status_stopped
        end

        puts ''
        state_code = ec2_resource.instance(instance_id).state.code
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.start_stop_status_loop] Status', state_code)
        state_string_past_tense = if desired_state == 'start'
                                    'Started'
                                  else
                                    'Stopped'
                                  end
        state_string_present_tense = if desired_state == 'start'
                                       'Start'
                                     else
                                       'Stop'
                                     end
        if state_code == desired_state_code
          Orchestrator::ConsoleOutputs.info_message_item("Instance #{state_string_past_tense}", instance_id)
        else
          Orchestrator::ConsoleOutputs.error_message_item("Instance Failed to #{state_string_present_tense}", instance_id)
        end
      end

      # skip_status true will skip the loop of waiting for it to be stopped. Good for if doing multiple instances so they run in parallel instead of series.
      def self.start_instance(instance_id, skip_status = false)
        ec2_resource = Orchestrator::AWS::EC2.ec2_resource
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.start_instance] instance_id', instance_id)

        instance = ec2_resource.instance(instance_id)
        case instance.state.code
        when 0 # pending
          Orchestrator::ConsoleOutputs.error_message_item('Pending, Cannot Start', instance_id)
        when 16  # started
          Orchestrator::ConsoleOutputs.message_item('Already Started', instance_id)
        when 64  # stopping
          Orchestrator::ConsoleOutputs.error_message_item('Stopping, Cannot Start', instance_id)
        when 48  # terminated
          Orchestrator::ConsoleOutputs.error_message_item('Terminated, Cannot Start', instance_id)
        else
          begin
            retries ||= 0
            Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.start_instance] retries', retries)
            Orchestrator::ConsoleOutputs.message_item('Starting Instance', instance_id)
            instance.start
          rescue StandardError => e
            Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.start_instance] Standard Error Output', e)
            Orchestrator::ConsoleOutputs.error_message_item('[Orchestrator::AWS::EC2.start_instance] - Rescue', retries)
            sleep 1
            retry if (retries += 1) < 10
          end

          Orchestrator::AWS::EC2.start_stop_status_loop(instance_id, 'start') unless skip_status
        end
      end

      # skip_status true will skip the loop of waiting for it to be stopped. Good for if doing multiple instances so they run in parallel instead of series.
      def self.stop_instance(instance_id, skip_status = false)
        ec2_resource = Orchestrator::AWS::EC2.ec2_resource
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.stop_instance] instance_id', instance_id)

        instance = ec2_resource.instance(instance_id)
        case instance.state.code
        when 48  # terminated
          Orchestrator::ConsoleOutputs.error_message_item('Terminated, Can not Stop', instance_id)
        when 64  # stopping
          Orchestrator::ConsoleOutputs.warning_message_item('Stopping, Will be Stopped Soon', instance_id)
        when 80  # stopped
          Orchestrator::ConsoleOutputs.message_item('Already Stopped', instance_id)
        else
          begin
            retries ||= 0
            Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.stop_instance] retries', retries)
            Orchestrator::ConsoleOutputs.message_item('Stopping Instance', instance_id)
            instance.stop
          rescue StandardError => e
            Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::EC2.stop_instance] Standard Error Output', e)
            Orchestrator::ConsoleOutputs.error_message_item('[Orchestrator::AWS::EC2.stop_instance] - Rescue', retries)
            sleep 1
            retry if (retries += 1) < 10
          end

          Orchestrator::AWS::EC2.start_stop_status_loop(instance_id, 'stop') unless skip_status
        end
      end
    end
  end
end
