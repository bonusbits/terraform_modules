namespace :bastion do
  namespace :tests do
    desc 'Loop Check Until Bastion EC2 Instance Status OK'
    task :instance_status_loop do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header('Bastion EC2 Instance Status Loop')
      Orchestrator::Bastion::Tests.instance_status_loop
    end

    desc 'Tail Cloud Init Log on Bastion Until Completed'
    task :tail_cloud_init_loop do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header('Tail Cloud Init Log on Bastion Until Completed')
      Orchestrator::Bastion::Tests.tail_cloud_init_loop
    end

    # desc 'Tail Cloud Init Log on Bastion Until Completed'
    # task :tail_cloud_init do
    #   Orchestrator::ConsoleOutputs.header
    #   Orchestrator::ConsoleOutputs.sub_header('Tail Cloud Init Log on Bastion Until Completed')
    #   Orchestrator::Bastion::Tests.tail_cloud_init
    # end
  end
end
