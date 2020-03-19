module Orchestrator
  # Setup Methods Specific to Local Setup
  module Local
    def self.show_local_env_vars
      command = <<-'VERSIONS'
        echo '***************************'
        echo '* Environment Variables'
        echo '***************************'
        env | grep AWS_
        env | grep KUB
        env | grep MONGODB_
        env | grep SLACK_
        env | grep TF_
        echo ''
        echo '***************************'
        echo '* Gem Environment'
        echo '***************************'
        gem env
      VERSIONS

      Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Local.show_local_env_vars] command', command)
      results = Orchestrator::Shell.run_command_strout(command)
      Orchestrator::ConsoleOutputs.message(results)
    end

    # TODO: ChefDK version not working -=Levon
    def self.show_local_versions
      command_list = {
        'AWS CLI      ' => 'aws --version | grep -o \'aws-cli\/[0-9]\+\.[0-9]\+\.[0-9]\+\' | grep -o \'[0-9]\+\.[0-9]\+\.[0-9]\+\'',
        'ChefWS       ' => 'cat /opt/chef-workstation/version-manifest.json | jq \'.build_version\' | grep -o \'[0-9]\+\.[0-9]\+\.[0-9]\+\'',
        'Docker       ' => 'docker --version | awk \'{print $3}\' | tr -d \'\n\' | head -c -1',
        'Git          ' => 'git version | grep -o \'[0-9]\+\.[0-9]\+\.[0-9]\+\'',
        'Helm         ' => 'helm version | grep -o \'v[0-9]\+\.[0-9]\+\.[0-9]\+\' | cut -c2-',
        'JQ           ' => 'jq --version | grep -o \'jq-[0-9]\+\.[0-9]\+\' | cut -c4-',
        'Kubectl      ' => 'kubectl version | grep \'Client Version\' | grep -o \'v[0-9]\+\.[0-9]\+\.[0-9]\+\' | cut -c2-',
        'Packer       ' => 'packer -v | head -c -1',
        'Ruby         ' => 'ruby --version | grep -o \'^ruby [0-9]\+\.[0-9]\+\.[0-9]\+\' | grep -o \'[0-9]\+\.[0-9]\+\.[0-9]\+\'',
        'RubyGems     ' => 'gem --version',
        ' colorize    ' => 'gem list colorize | grep -o \'[0-9]\+\.[0-9]\+\.[0-9]\+\'',
        ' deep_merge  ' => 'gem list deep_merge | grep -o \'[0-9]\+\.[0-9]\+\.[0-9]\+\'',
        ' rubocop-rake' => 'gem list rubocop-rake | grep -o \'[0-9]\+\.[0-9]\+\.[0-9]\+\'',
        'Terraform    ' => 'terraform --version | awk \'/^Terraform v[0-9]/ { print substr($2,2) }\''
      }

      Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Local.show_local_versions] command_list', command_list)

      command_list.each do |item, command|
        results = Orchestrator::Shell.run_command_strout(command).strip
        Orchestrator::ConsoleOutputs.message_item(item, results)
      end
    end
  end
end
