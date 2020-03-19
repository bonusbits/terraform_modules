namespace :web do
  namespace :status do
    desc 'Get HTTP Return Code Locally - rake web:status:http_code_local[https://www.bonusbits.com]'
    task :http_code_local, [:url] do |_task, args|
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header_item('HTTP Code', (args[:url]).to_s)
      http_code = Orchestrator::Web::Status.http_code_local(args[:url])
      Orchestrator::ConsoleOutputs.message_item('HTTP Code', http_code)
    end

    desc 'Get HTTP Return Code from Bastion - rake web:status:http_code_bastion[https://www.bonusbits.com]'
    task :http_code_bastion, [:url] do |_task, args|
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header_item('HTTP Code from Bastion', args[:url])
      Orchestrator::Web::Status.http_code_bastion(args[:url])
    end

    desc 'Check if HTTP OK Locally - rake web:status:http_code_local[https://www.bonusbits.com]'
    task :http_ok_local, [:url] do |_task, args|
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header_item('HTTP OK', (args[:url]).to_s)
      http_ok = Orchestrator::Web::Status.http_ok_local(args[:url])
      Orchestrator::ConsoleOutputs.message_item('HTTP OK', http_ok)
    end
  end
end
