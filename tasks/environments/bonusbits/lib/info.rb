module Orchestrator
  module BonusBits
    module Info
      def self.summary
        unless $project_vars['orchestrator']['environment'] == 'bonusbits'
          Orchestrator::ConsoleOutputs.error_message('Not an bonusbits Environment')
          return
        end

        network_state = Orchestrator::Terraform::Fetch.specific_state_output('network')
        if network_state.empty?
          Orchestrator::ConsoleOutputs.exclamation_sub_header('MISSING: Network State File')
          Orchestrator::ConsoleOutputs.message('Network Created?')
          return
        end
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
