namespace :aws do
  namespace :alb do
    desc 'Check All App ALB Target Groups Until First Instance is Healthy'
    task :check_target_healthy_app do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header('Check Each App ALB Target Groups Until Healthy')
      Orchestrator::Terraform::Fetch.app_lb_target_group_arns.each do |key, value|
        Orchestrator::ConsoleOutputs.sub_header_item('ALB Target Health', key)
        target_healthy = Orchestrator::AWS::ALB.check_target_group_health_loop(key, value)
        raise Orchestrator::ConsoleOutputs.error_message_item('Target Not Healthy', target_healthy) unless target_healthy
      end
    end

    desc 'Check All K8S ALB Target Groups Until First Instance is Healthy'
    task :check_target_healthy_k8s do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header('Check Each K8S ALB Target Groups Until Healthy')
      vpc_id = Orchestrator::Terraform::Fetch.vpc_id
      Orchestrator::AWS::ALB.target_group_arns_k8s(vpc_id).each do |key, value|
        Orchestrator::ConsoleOutputs.sub_header_item('K8S ALB Target Health', key)
        target_healthy = Orchestrator::AWS::ALB.check_target_group_health_loop(key, value)
        raise Orchestrator::ConsoleOutputs.error_message_item('Target Not Healthy', target_healthy) unless target_healthy
      end
    end
  end
end
