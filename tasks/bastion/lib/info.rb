module Orchestrator
  module Bastion
    module Info
      def self.summary
        Orchestrator::ConsoleOutputs.sub_header('Bastion Summary')

        state = $all_terraform_states.nil? || $all_terraform_states['bastion'].nil? ? Orchestrator::Terraform::Fetch.specific_state_output('bastion', true) : $all_terraform_states['bastion']

        if state['load_balancer']
          public_ip = state['load_balancer']['value']['dns_name']
          public_type = 'load_balancer'
        elsif state['eip']
          public_ip = state['eip']['value']['eip']['public_ip']
          public_type = 'eip'
        else
          public_ip = state['ec2_instance']['value']['instance']['public_ip']
          public_type = 'public_ip'
        end

        availability_zone = state['ec2_instance']['value']['instance']['availability_zone'].nil? ? 'UNKNOWN' : state['ec2_instance']['value']['instance']['availability_zone']
        iam_instance_profile = state['ec2_instance']['value']['instance']['iam_instance_profile'].nil? ? 'UNKNOWN' : state['ec2_instance']['value']['instance']['iam_instance_profile']
        instance_id = state['ec2_instance']['value']['instance']['id'].nil? ? 'UNKNOWN' : state['ec2_instance']['value']['instance']['id']
        key_name = state['ec2_instance']['value']['instance']['key_name'].nil? ? 'UNKNOWN' : state['ec2_instance']['value']['instance']['key_name']
        instance_type = state['ec2_instance']['value']['instance']['instance_type'].nil? ? 'UNKNOWN' : state['ec2_instance']['value']['instance']['instance_type']
        os_distro = state['os_distro']['value'].nil? ? 'UNKNOWN' : state['os_distro']['value']
        local_dns = state['ec2_instance']['value']['dns']['fqdn'].nil? ? 'UNKNOWN' : state['ec2_instance']['value']['dns']['fqdn']
        private_ip = state['ec2_instance']['value']['instance']['private_ip'].nil? ? 'UNKNOWN' : state['ec2_instance']['value']['instance']['private_ip']
        security_group_ids = state['ec2_instance']['value']['instance']['vpc_security_group_ids'].nil? ? 'UNKNOWN' : state['ec2_instance']['value']['instance']['vpc_security_group_ids']
        subnet_id = state['ec2_instance']['value']['instance']['subnet_id'].nil? ? 'UNKNOWN' : state['ec2_instance']['value']['instance']['subnet_id']

        values = {
          'Availability Zone' => availability_zone,
          'Instance Profile' => iam_instance_profile,
          'Instance ID' => instance_id,
          'Instance Type' => instance_type,
          'Key Pair' => key_name,
          'Local DNS' => local_dns,
          'OS Distro' => os_distro,
          'Private IP' => private_ip,
          'Public IP' => public_ip,
          'Public Type' => public_type,
          'Security Group IDs' => security_group_ids,
          'Subnet ID' => subnet_id
        }

        values.each do |key, value|
          space_count = (26 - key.length)
          puts "- #{key}".colorize(:light_green) + (' ' * space_count) + '('.colorize(:light_green) + value.to_s.colorize(:cyan) + ')'.colorize(:light_green)
        end
      end
    end
  end
end
