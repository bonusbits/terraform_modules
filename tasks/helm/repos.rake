namespace :helm do
  namespace :repos do
    desc 'Add EKS Charts'
    task :add_eks_charts do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header('Add EKS Charts to Helm')
      Orchestrator::Helm::Repos.add('eks-charts', 'https://aws.github.io/eks-charts')
    end

    desc 'Remove EKS Charts'
    task :remove_eks_charts do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header('Remove EKS Charts to Helm')
      Orchestrator::Helm::Repos.remove('eks-charts')
    end

    desc 'List Repos Charts'
    task :list_charts, [:repo] do |_task, args|
      args.with_defaults(repo: nil)
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header_item('List Repos Charts', args[:repo].nil? ? 'all repos' : args[:repo])
      Orchestrator::Helm::Repos.list_charts(args[:repo])
    end

    desc 'Update Helm Repos'
    task :update do
      Orchestrator::ConsoleOutputs.header
      Orchestrator::ConsoleOutputs.sub_header('Update Helm Repos')
      Orchestrator::Helm::Repos.update
    end
  end
end

desc 'Alias (helm:repos:list_charts[repo])'
task :helm_list_charts, [:repo] do |_task, args|
  args.with_defaults(repo: nil)
  Rake::Task['helm:repos:list_charts'].invoke(args[:repo])
end

desc 'Alias (helm:repos:update)'
task helm_update_repos: %w[helm:repos:update]
