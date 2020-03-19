module Orchestrator
  module Terraform
    module Cli
      # A Filter Solution to run all Roles or a Single Role
      def self.command(exec, sub_header, item = nil)
        Orchestrator::ConsoleOutputs.header
        if item.nil?
          $project_vars['terraform']['roles'].each do |role|
            Orchestrator::ConsoleOutputs.sub_header_item(sub_header, role)
            Orchestrator::Terraform::Cli.terraform_command_path(exec, role)
          end
        else
          Orchestrator::ConsoleOutputs.sub_header_item(sub_header, item)
          Orchestrator::Terraform::Cli.terraform_command_path(exec, item)
        end
      end

      # A Filter Solution to run all Roles or a Single Role
      # with TFVARS and CLI VARS in the Terraform Command
      def self.command_tfvars(exec, sub_header, role = nil)
        Orchestrator::ConsoleOutputs.header
        if role.nil?
          $project_vars['terraform']['roles'].each do |r|
            Orchestrator::ConsoleOutputs.sub_header_item(sub_header, r)
            Orchestrator::Terraform::Cli.terraform_tfvars_command_path(exec, r)
          end
        else
          Orchestrator::ConsoleOutputs.sub_header_item(sub_header, role)
          Orchestrator::Terraform::Cli.terraform_tfvars_command_path(exec, role)
        end
      end

      # Only used for init. Once initialized the information is stored .terraform/
      def self.load_backend_vars
        backend_config = Hash.new
        backend_config['backend_bucket'] = "-backend-config=\"bucket=#{$project_vars['terraform']['s3_backend']['bucket']}\""
        backend_config['backend_region'] = "-backend-config=\"region=#{$project_vars['terraform']['s3_backend']['region']}\""
        backend_config['backend_key_prefix'] = "-backend-config=\"workspace_key_prefix=#{$project_vars['terraform']['s3_backend']['key_prefix']}\""

        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Terraform::Cli.load_backend_vars] backend_config', backend_config)
        backend_config
      end

      def self.load_common_vars
        common_vars = Hash.new
        common_vars['aws_region'] = "AWS_REGION=#{$project_vars['aws']['region']} AWS_DEFAULT_REGION=#{$project_vars['aws']['region']}"
        common_vars['aws_profile'] = "AWS_PROFILE=#{$project_vars['aws']['profile']}"
        common_vars['tf_workspace'] = "TF_WORKSPACE=#{$project_vars['terraform']['workspace']}"
        common_vars['orchestrator_version'] = "-var=\"orchestrator_version=#{Orchestrator::Vars.orchestrator_version}\""
        common_vars['terraform_version'] = "-var=\"terraform_version=#{Orchestrator::Terraform::Vars.local_version}\""
        common_vars['terraform_environment'] = "-var=\"terraform_environment=#{$project_vars['orchestrator']['environment']}\""
        # String hacks to convert the Ruby hash output to HCL Terraform style
        common_vars['s3_backend'] = "-var='s3_backend=#{$project_vars['terraform']['s3_backend'].to_s.gsub('=>', ':').gsub(' ', '')}'"

        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Terraform::Cli.load_common_vars] common_vars', common_vars)
        common_vars
      end

      # Take Array of tfvar files and make one long string for use in terraform cli
      def self.tf_var_files_cli(role)
        command_string = String.new

        unless $project_vars['terraform']['shared_tfvar_files'].nil? || $project_vars['terraform']['shared_tfvar_files'].empty?
          $project_vars['terraform']['shared_tfvar_files'].each do |tf_var_file|
            command_string << " -var-file=#{$project_vars['orchestrator']['orchestrator_path']}/#{tf_var_file}"
          end
        end

        # Load Common TF Vars
        common_tfvar_fullname = "#{$project_vars['orchestrator']['orchestrator_path']}/#{$project_vars['terraform']['tfvar_roles_path']}/custom_aws_tags.tfvars"
        command_string << " -var-file=#{common_tfvar_fullname}" if File.exist?(common_tfvar_fullname)

        # Load Role TF Vars
        role_tfvar_fullname = "#{$project_vars['orchestrator']['orchestrator_path']}/#{$project_vars['terraform']['tfvar_roles_path']}/#{role}.tfvars"
        command_string << " -var-file=#{role_tfvar_fullname}" if File.exist?(role_tfvar_fullname)

        # Load Role based Secrets TF Vars
        secrets_tfvar_path = "#{$project_vars['orchestrator']['secrets_path']}/#{$project_vars['terraform']['workspace']}"
        secrets_tfvar_fullname = "#{secrets_tfvar_path}/#{role}.tfvars"
        command_string << " -var-file=#{secrets_tfvar_fullname}" if File.exist?(secrets_tfvar_fullname)

        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Terraform::Cli.tf_var_files_cli] command_string', command_string)
        command_string
      end

      # Runs the Terraform Command with TFVars
      def self.terraform_tfvars_command(command, role, arg1 = nil, arg2 = nil)
        common_vars = Orchestrator::Terraform::Cli.load_common_vars
        tf_var_files_cli = Orchestrator::Terraform::Cli.tf_var_files_cli(role)
        c1 = "#{common_vars['tf_workspace']} #{common_vars['aws_region']} #{common_vars['aws_profile']} terraform #{command} #{tf_var_files_cli.strip} #{common_vars['orchestrator_version']} #{common_vars['terraform_version']} #{common_vars['terraform_environment']} #{common_vars['s3_backend']}"
        c2 = " #{arg1}"
        c3 = " #{arg2}"

        # Removes spaces if nils
        command_string = c1.strip + c2 + c3
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Terraform::Cli.terraform_tfvars_command] command_string', command_string)
        system(command_string)
      end

      # Change to Role Directory then Call Run Command with TFVars
      def self.terraform_tfvars_command_path(command, role, arg1 = nil, arg2 = nil)
        Dir.chdir("#{$project_vars['orchestrator']['orchestrator_path']}/terraform/environments/#{$project_vars['orchestrator']['environment']}/#{role}") do
          Orchestrator::Terraform::Cli.terraform_tfvars_command(command, role, arg1, arg2)
        end
      end

      # Runs the Terraform Command without TFVars
      def self.terraform_command(command, arg1 = nil, arg2 = nil)
        common_vars = Orchestrator::Terraform::Cli.load_common_vars
        system "#{common_vars['tf_workspace']} #{common_vars['aws_region']} #{common_vars['aws_profile']} terraform #{command} #{arg1} #{arg2}"
      end

      # Change to Role Directory then Call Run Command without TFVars
      def self.terraform_command_path(command, role, arg1 = nil, arg2 = nil)
        Dir.chdir("#{$project_vars['orchestrator']['orchestrator_path']}/terraform/environments/#{$project_vars['orchestrator']['environment']}/#{role}") do
          Orchestrator::Terraform::Cli.terraform_command(command, arg1, arg2)
        end
      end
    end
  end
end
