module Orchestrator
  module Packer
    module Cli
      def self.load_command_vars
        command_vars = String.new
        command_vars << "--var region=#{$project_vars['aws']['region']}"
        command_vars << " --var vpc_id=#{Orchestrator::Terraform::Fetch.vpc_id}"
        command_vars << " --var subnet_id=#{Orchestrator::Terraform::Fetch.subnet_ids('dmz')[0]}"
        command_vars << " --var orchestrator_version=#{Orchestrator::Vars.orchestrator_version}"
        command_vars << " --var packer_version=#{Orchestrator::Packer::Vars.local_version}"
        command_vars
      end

      # A Filter Solution to run all Roles or a Single Role
      def self.command_chdir(command, sub_header, image, role)
        Orchestrator::ConsoleOutputs.header
        Orchestrator::ConsoleOutputs.sub_header_item(sub_header, "#{image}/#{role}")

        command_vars = Orchestrator::Packer::Cli.load_command_vars

        Dir.chdir("#{$project_vars['orchestrator']['orchestrator_path']}/packer/images/environments/#{$project_vars['orchestrator']['environment']}/#{image}") do
          system "packer #{command} #{command_vars} --var-file=#{$project_vars['orchestrator']['orchestrator_path']}/packer/vars/environments/#{$project_vars['orchestrator']['environment']}/#{image}/#{role}.pkrvars.hcl ."
        end
      end
    end
  end
end
