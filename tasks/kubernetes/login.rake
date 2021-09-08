namespace :kubernetes do
  namespace :login do
    desc 'Kubernetes Login Node Group EC2 Instance'
    task :eks_node do
      Orchestrator::ConsoleOutputs.header
      node_ip = Orchestrator::Kubernetes::Nodes.node_ip
      Orchestrator::ConsoleOutputs.sub_header_item('Kubernetes Login Node Group EC2 Instance', "#{node_ip}/eks/ec2-user")
      Orchestrator::Bastion::Login.proxy_ip(node_ip, 'eks', $project_vars['bastion']['login_user'], 'ec2-user')
    end
  end
end

desc 'Alias (kubernetes:login:eks_node)'
task login_eks_node: %w[kubernetes:login:eks_node]
