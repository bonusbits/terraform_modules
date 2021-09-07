module Orchestrator
  # Amazon Web Services
  module Bastion
    # Elastic Compute Cloud
    module EC2
      def self.create_ami
        instance_id = Orchestrator::Bastion::Terraform.instance_id
        Orchestrator::AWS::EC2.create_ami('bastion', instance_id)
      end

      def self.start_instance
        instance_id = Orchestrator::Bastion::Terraform.instance_id
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Bastion::EC2.start_instance] instance_id', instance_id)
        Orchestrator::AWS::EC2.start_instance(instance_id)
      end

      def self.stop_instance
        # Make sure state is up-to-date
        Rake::Task['terraform:refresh'].invoke('bastion')
        instance_id = Orchestrator::Bastion::Terraform.instance_id
        Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Bastion::EC2.stop_instance] instance_id', instance_id)
        Orchestrator::AWS::EC2.stop_instance(instance_id)
      end
    end
  end
end
