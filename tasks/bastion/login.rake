namespace :bastion do
  namespace :login do
    desc 'Login to Bastion Host'
    task :direct do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header('Login to Bastion')
      Orchestrator::Bastion::Login.direct
    end

    desc 'Login to Private Via Bastion  - (rake bastion:login:proxy_instance[web])'
    task :proxy_instance, [:type, :instance_name] do |_task, args|
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header_item('Login Through Bastion to', args[:instance_name])
      Orchestrator::Bastion::Login.proxy_instance(args[:type], (args[:instance_name]).to_s)
    end

    desc 'Login to Private IP Via Bastion  - (rake bastion:login:proxy_ip[172.25.32.105,eks,ec2-user])'
    task :proxy_ip, [:ip, :ssh_key, :user_name] do |_task, args|
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header_item('Login Through Bastion to', "#{args[:ip]}/#{args[:ssh_key]}/#{args[:user_name]}")
      Orchestrator::Bastion::Login.proxy_ip((args[:ip]).to_s, (args[:ssh_key]).to_s, (args[:user_name]).to_s)
    end
  end
end

desc 'Alias (bastion:login:direct)'
task login_bastion: %w[bastion:login:direct]

desc 'Alias (bastion:login:proxy_ip[ip,ssh_key,username])'
task :login_private_ip, [:ip, :ssh_key, :user_name] do |_task, args|
  Rake::Task['bastion:login:proxy_ip'].invoke(args[:ip], args[:ssh_key], args[:user_name])
end
