module Orchestrator
  module BonusBits
    module Info
      def self.network
        unless $project_vars['orchestrator']['environment'] == 'bonusbits'
          Orchestrator::ConsoleOutputs.error_message('Not an bonusbits Environment')
          return
        end

        unless $project_vars['terraform']['roles'].include?('network')
          Orchestrator::ConsoleOutputs.exclamation_sub_header('MISSING: vpc in Rake Config')
          return
        end

        state = $all_terraform_states.nil? || $all_terraform_states['network'].nil? ? Orchestrator::Terraform::Fetch.specific_state_output('network', true) : $all_terraform_states['network']
        if state.empty?
          Orchestrator::ConsoleOutputs.exclamation_sub_header('MISSING: Network State File')
          return
        end
        Orchestrator::ConsoleOutputs.sub_header('Network')

        unless state['nat_public_ip'].nil? || state['nat_public_ip'].empty?
          puts 'NAT'.colorize(:cyan)
          puts '- Public IP              ('.colorize(:light_green) + (state['nat_public_ip']['value']).to_s.colorize(:cyan) + ')'.colorize(:light_green)
        end

        puts 'VPC'.colorize(:cyan)
        puts '- Set Availability Zones ('.colorize(:light_green) + (state['set_availability_zones']['value']).to_s.colorize(:cyan) + ')'.colorize(:light_green)
        puts '- Region                 ('.colorize(:light_green) + (state['region']['value']).to_s.colorize(:cyan) + ')'.colorize(:light_green)
        puts '- Public Route Table     ('.colorize(:light_green) + (state['route_tables']['value']['public']['id']).to_s.colorize(:cyan) + ')'.colorize(:light_green)
        private_rtb_list = Array.new
        state['route_tables']['value']['private'].each do |rtb|
          private_rtb_list << rtb['id']
        end
        puts '- Private Route Tables   ('.colorize(:light_green) + private_rtb_list.to_s.colorize(:cyan) + ')'.colorize(:light_green)
        puts '- Subnets'.colorize(:light_green)
        state['subnets']['value'].each do |key, value|
          next if value.empty?

          space_count = (21 - key.length)
          subnet_ids = Array.new
          value.each do |subnet|
            subnet_ids << subnet['id']
          end
          puts "  - #{key}".colorize(:light_green) + (' ' * space_count) + '('.colorize(:light_green) + (subnet_ids.to_s).colorize(:cyan) + ')'.colorize(:light_green)
        end

        puts '- VPC ID                 ('.colorize(:light_green) + (state['vpc']['value']['id']).to_s.colorize(:cyan) + ')'.colorize(:light_green)
      end

      def self.summary
        unless $project_vars['orchestrator']['environment'] == 'bonusbits'
          Orchestrator::ConsoleOutputs.error_message('Not an bonusbits Environment')
          return
        end

        network_state = Orchestrator::Terraform::Fetch.specific_state_output('network')
        Orchestrator::ConsoleOutputs.sub_header('Stack Summary')

        vpc_id = network_state.nil? ? 'UNKNOWN' : network_state['vpc']['value']['id']
        set_availability_zones = network_state.nil? ? 'UNKNOWN' : network_state['set_availability_zones']['value']
        nat_eips = network_state.nil? ? 'UNKNOWN' : network_state['nat_public_ip']['value']
        dns_zone_private = network_state.nil? ? 'UNKNOWN' : network_state['dns_zone_private']['value']['name']
        dns_zone_private_id = network_state.nil? ? 'UNKNOWN' : network_state['dns_zone_private']['value']['id']

        subnet_cidr_blocks = Hash.new
        network_state['subnets']['value'].each do |key, value|
          subnet_cidr_blocks[key] = value[0]['cidr_block']
        end

        queue_values = {
          'Setup Availability Zones' => set_availability_zones,
          'DNS Private Zone' => dns_zone_private,
          'DNS Private Zone ID' => dns_zone_private_id,
          'NAT EIPs' => nat_eips,
          'Subnets CIDR Blocks' => subnet_cidr_blocks,
          'VPC ID' => vpc_id
        }

        queue_values.each do |key, value|
          space_count = (26 - key.length)
          puts "- #{key}".colorize(:light_green) + (' ' * space_count) + '('.colorize(:light_green) + value.to_s.colorize(:cyan) + ')'.colorize(:light_green)
        end
      end
    end
  end
end
