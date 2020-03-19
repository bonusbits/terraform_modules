module Orchestrator
  module AWS
    module S3
      def self.download(force = false)
        local_state_files_path = "#{$project_vars['orchestrator']['orchestrator_path']}/tmp/#{$project_vars['terraform']['workspace']}"
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::S3.download] force', force)

        system("rm -rf #{local_state_files_path}/*.tfstate") if force

        command_list = [
          "mkdir -p #{local_state_files_path}",
          "aws s3 sync --region #{$project_vars['terraform']['s3_backend']['region']} --profile #{$project_vars['aws']['profile']} \"s3://#{$project_vars['terraform']['s3_backend']['bucket']}/#{$project_vars['terraform']['s3_backend']['key_prefix']}/#{$project_vars['terraform']['workspace']}\" \"#{local_state_files_path}\""
        ]
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::S3.download] Command List', command_list)
        command_list.each do |command|
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::S3.download] Executing Command', command)
          system(command)
        end
      end

      def self.upload(role)
        local_state_files_path = "#{$project_vars['orchestrator']['orchestrator_path']}/tmp/#{$project_vars['terraform']['workspace']}"
        command = "aws s3 cp --region #{$project_vars['terraform']['s3_backend']['region']} --profile #{$project_vars['aws']['profile']}  \"#{local_state_files_path}/#{role}.tfstate\" \"s3://#{$project_vars['terraform']['s3_backend']['bucket']}/#{$project_vars['terraform']['s3_backend']['key_prefix']}/#{$project_vars['terraform']['workspace']}/#{role}.tfstate\""
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::S3.download] Executing Command', command)
        system(command)
      end

      def self.upload_all
        local_state_files_path = "#{$project_vars['orchestrator']['orchestrator_path']}/tmp/#{$project_vars['terraform']['workspace']}"
        Dir.glob("#{local_state_files_path}/*.tfstate").each do |file|
          command = "aws s3 cp --region #{$project_vars['terraform']['s3_backend']['region']} --profile #{$project_vars['aws']['profile']}  \"#{file}\" \"s3://#{$project_vars['terraform']['s3_backend']['bucket']}/#{$project_vars['terraform']['s3_backend']['key_prefix']}/#{$project_vars['terraform']['workspace']}/\""
          Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::AWS::S3.download] Executing Command', command)
          system(command)
        end
      end
    end
  end
end
