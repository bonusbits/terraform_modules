module Orchestrator
  module Bastion
    module Terraform
      def self.bastion_ip
        state = $all_terraform_states.nil? || $all_terraform_states['bastion'].nil? ? Orchestrator::Terraform::Fetch.specific_state_output('bastion', true) : $all_terraform_states['bastion']
        results = if state['load_balancer']
                    state['load_balancer']['value']['dns_name']
                  elsif state['eip']
                    state['eip_public_ips']['value'][0]
                  else
                    state['ec2_instance']['value']['instance']['public_ip']
                  end
        raise Orchestrator::ConsoleOutputs.error_message('[Orchestrator::Bastion::Terraform.bastion_ip] Return Nil') if results.nil?

        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Bastion::Terraform.bastion_ip] Return', results)
        results
      end

      def self.instance_id
        state = Orchestrator::Terraform::Fetch.specific_state_output('bastion')
        instance_id = state['ec2_instance']['value']['instance']['id']
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Terraform::Fetch.instance_id] Return', instance_id)
        instance_id
      end
    end
  end
end
