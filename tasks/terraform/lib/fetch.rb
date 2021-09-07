module Orchestrator
  module Terraform
    module Fetch
      # Downloads Terraform Outputs from S3 State Files for All Roles and Stores in Global Variable
      def self.all_state_outputs(force = false)
        return unless $all_terraform_states.nil? || force

        require 'json'
        Orchestrator::ConsoleOutputs.info_message('Fetching All Terraform State Outputs...')
        aws_region = "AWS_REGION=#{$project_vars['aws']['region']} AWS_DEFAULT_REGION=#{$project_vars['aws']['region']}"
        aws_profile = "AWS_PROFILE=#{$project_vars['aws']['profile']}"
        tf_workspace = "TF_WORKSPACE=#{$project_vars['terraform']['workspace']}"
        $all_terraform_states = Hash.new
        $project_vars['terraform']['roles'].each do |role|
          @state_json = nil
          Dir.chdir("#{$project_vars['orchestrator']['orchestrator_path']}/terraform/environments/#{$project_vars['orchestrator']['environment']}/#{role}") do
            Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Terraform::Fetch.all_state_outputs] Fetching State File', role)
            @state_json = Orchestrator::Shell.run_command_strout("#{tf_workspace} #{aws_region} #{aws_profile} terraform output -json")
          end
          $all_terraform_states[role] = JSON.parse(@state_json)
        end
        $all_terraform_states
      end

      # Returns Ruby Hash of Terraform State Outputs
      def self.specific_state_output(role, add_to_global_var = false)
        require 'json'
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Terraform::Fetch.specific_state_output] Fetching Terraform State Outputs for', role.to_s)
        role_path = "#{$project_vars['orchestrator']['orchestrator_path']}/terraform/environments/#{$project_vars['orchestrator']['environment']}/#{role}"
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Terraform::Fetch.specific_state_output] role_path', role_path)
        Dir.chdir(role_path) do
          aws_region = "AWS_REGION=#{$project_vars['aws']['region']} AWS_DEFAULT_REGION=#{$project_vars['aws']['region']}"
          aws_profile = "AWS_PROFILE=#{$project_vars['aws']['profile']}"
          tf_workspace = "TF_WORKSPACE=#{$project_vars['terraform']['workspace']}"
          @terraform_state_json = Orchestrator::Shell.run_command_strout("#{tf_workspace} #{aws_region} #{aws_profile} terraform output -json")
        end
        parsed_json = JSON.parse(@terraform_state_json)
        if add_to_global_var
          $all_terraform_states = Hash.new if $all_terraform_states.nil?
          $all_terraform_states[role] = parsed_json
        end
        parsed_json
      end

      # Return Array of Subnet IDs for a Specific Subnet (public, private, scadmin)
      def self.subnet_ids(name)
        Orchestrator::ConsoleOutputs.debug_message('[Orchestrator::Terraform::Fetch.subnet_id] Fetching Subnet ID from Terraform State')
        state = $all_terraform_states.nil? || $all_terraform_states['vpc'].nil? ? Orchestrator::Terraform::Fetch.specific_state_output('vpc', true) : $all_terraform_states['vpc']
        subnet_id = state['subnet_ids']['value'][name]
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Terraform::Fetch.subnet_id] Fetching Subnet ID', subnet_id)
        subnet_id
      end

      def self.vpc_id
        Orchestrator::ConsoleOutputs.debug_message('[Orchestrator::Terraform::Fetch.vpc_id] Fetching VPC ID from Terraform State')
        state = $all_terraform_states.nil? || $all_terraform_states['vpc'].nil? ? Orchestrator::Terraform::Fetch.specific_state_output('vpc', true) : $all_terraform_states['vpc']
        vpc_id = state['vpc']['value']['id']
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Terraform::Fetch.vpc_id] Fetching VPC ID', vpc_id)
        vpc_id
      end

      # Returns VPN Endpoint ID (cvpn-endpoint-0e77bd549e0a954ff)
      def self.vpn_endpoint_id
        Orchestrator::ConsoleOutputs.debug_message('[Orchestrator::Terraform::Fetch.vpn_endpoint_id] Fetching MongoDB Atlas Cluster ID From Terraform')
        network_state = $all_terraform_states.nil? || $all_terraform_states['vpc'].nil? ? Orchestrator::Terraform::Fetch.specific_state_output('vpc', true) : $all_terraform_states['vpc']
        endpoint_id = network_state['vpn_endpoint']['value']['id']
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Terraform::Fetch.vpn_endpoint_id] endpoint_id', endpoint_id)
        endpoint_id
      end
    end
  end
end
