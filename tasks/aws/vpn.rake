namespace :aws do
  namespace :vpn do
    desc 'Create and Import Client Certs'
    task :create_client_certs, [:username] do |_task, args|
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header_item('Create and Import Client Certs', args[:username])
      Orchestrator::AWS::VPN.create_user_certs(args[:username])
    end

    desc 'Create Client Config'
    task :create_client_config, [:username] do |_task, args|
      # TODO: Add VPN Endpoint ID Fetch from Terraform
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header_item('Create Client Config', args[:username])
      Orchestrator::AWS::VPN.create_user_config(args[:username])
    end

    desc 'Create Server and Client Certificates for VPN Endpoint Locally'
    task :create_server_certificates do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header('Create Server and Client Certificates for VPN Endpoint Locally')
      Orchestrator::AWS::VPN.create_server_certificates
    end

    desc 'Stage Easy RSA'
    task :stage_easy_rsa do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header('Stage Easy RSA')
      Orchestrator::AWS::VPN.stage_easy_rsa
    end

    desc 'Upload Server and Client Certificates to ACM for VPN Endpoint'
    task :upload_server_certificates do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header('Upload Server and Client Certificates to ACM for VPN Endpoint')
      Orchestrator::AWS::VPN.upload_server_certificates
    end
  end
end
