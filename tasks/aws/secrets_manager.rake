namespace :aws do
  namespace :secrets_manager do
    desc 'Get Secret'
    task :display_secret, [:secret_name] do |_task, args|
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header('Secrets Manager Get Secret')
      secret = Orchestrator::AWS::SecretsManager.get_secret(args[:secret_name])

      require 'json'
      secret_hash = JSON.parse(secret)
      Orchestrator::ConsoleOutputs.debug_message_item('secret_json class', secret_hash.class)

      require 'pry'
      ::Pry::ColorPrinter.pp(secret_hash)
    end
  end
end
