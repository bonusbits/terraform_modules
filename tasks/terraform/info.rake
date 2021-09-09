namespace :terraform do
  namespace :info do
    desc 'EKS App ALB Hostname'
    task :eks_apps_alb_hostname do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header('EKS App ALB Hostname')
      alb_hostname = Orchestrator::BonusBits::Info.eks_apps_alb_hostname
      Orchestrator::ConsoleOutputs.message_item('EKS App ALB Hostname', alb_hostname)
    end

    desc 'Display Network Info'
    task :network do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::BonusBits::Info.network
    end

    desc 'Display Stack Summary'
    task :summary do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::BonusBits::Info.summary
    end
  end
end

desc 'Alias (terraform:info:summary)'
task info: %w[terraform:info:summary]

desc 'Alias (terraform:info:eks_apps_alb_hostname)'
task info_eks_alb_hostname: %w[terraform:info:eks_apps_alb_hostname]

desc 'Alias (terraform:info:network)'
task info_network: %w[terraform:info:network]
