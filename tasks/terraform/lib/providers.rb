module Orchestrator
  module Terraform
    module Providers
      # Change to Role Directory then Delete Providers
      def self.delete_role_cache(role)
        command = <<-'RMPROVIDERS'
          #!/usr/bin/env bash

          echo ''
          echo 'INFO: Removing .terraform/providers Directory'
          rm -rf .terraform/providers/*

          echo ''
          echo 'INFO: Removing .terraform.lock.hcl'
          rm -f .terraform.lock.hcl

          echo ''
          echo 'INFO: Now Run Init'
        RMPROVIDERS

        Dir.chdir("#{$project_vars['orchestrator']['orchestrator_path']}/terraform/environments/#{$project_vars['orchestrator']['environment']}/#{role}") do
          system(command)
        end
      end

      # Change to Role Directory then Delete Providers
      def self.delete_global_cache(path)
        # To avoid deleting at root of system
        raise Orchestrator::ConsoleOutputs.error_message('Global Cache Path Empty') if path.nil? || path.empty?

        return Orchestrator::ConsoleOutputs.warning_message_item('Global Cache Path Does Not Exist', path) unless File.exist?(path)

        command = <<-RMPROVIDERS
          #!/usr/bin/env bash

          echo ''
          echo 'INFO: Remove All Terraform Providers in Cache Path (#{path})'
          rm -rf #{path}/*

          echo ''
          echo 'INFO: Now Run Init'
        RMPROVIDERS

        system(command)
      end
    end
  end
end
