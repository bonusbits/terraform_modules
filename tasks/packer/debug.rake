namespace :packer do
  namespace :debug do
    desc 'Show Packer CLI Common Vars'
    task :show_common_vars do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header('Packer CLI Common Vars')
      Orchestrator::Packer::Vars.show_common_vars
    end
  end
end

desc 'Alias (packer:debug:show_common_vars)'
task show_packer_common_vars: %w[packer:debug:show_common_vars]
