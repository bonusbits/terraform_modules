# namespace :bonusbits do
#   namespace :login do
#     desc 'Kubernetes Login Web App'
#     task :web do
#       Orchestrator::ConsoleOutputs.header
#       Orchestrator::ConsoleOutputs.sub_header('Kubernetes Login Web App')
#       Orchestrator::Kubernetes::Login.pod('bonusbits', 'web')
#     end
#   end
# end
#
# desc 'Alias (bonusbits:login:web)'
# task login_web: %w[bonusbits:login:web]
