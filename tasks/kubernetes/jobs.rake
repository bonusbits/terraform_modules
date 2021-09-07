namespace :kubernetes do
  namespace :jobs do
    desc 'Kubernetes Describe a Job'
    task :describe_job, [:namespace, :job_name] do |_task, args|
      Orchestrator::ConsoleOutputs.header
      namespace = args[:namespace]
      Orchestrator::ConsoleOutputs.sub_header_item('Kubernetes Describe Job', "namespace=#{namespace}, jobname=#{args[:job_name]}")
      Orchestrator::Kubernetes::Jobs.describe_job(namespace, args[:job_name])
    end

    desc 'Kubernetes Get Jobs'
    task :get_jobs, [:namespace, :verbose] do |_task, args|
      Orchestrator::ConsoleOutputs.header
      namespace = args[:namespace].nil? ? 'all' : args[:namespace]
      verbose = args[:verbose] == 'verbose' || args[:verbose] == 'true'
      Orchestrator::ConsoleOutputs.sub_header_item('Kubernetes Get Jobs', "namespace=#{namespace}, verbose=#{verbose}")
      Orchestrator::Kubernetes::Jobs.get_jobs(namespace, verbose)
    end
  end
end

desc 'Alias (kubernetes:jobs:describe_job[namespace,job_name])'
task :k8s_desc_job, [:namespace, :job_name] do |_task, args|
  Rake::Task['kubernetes:jobs:describe_job'].invoke(args[:namespace], args[:job_name])
end

desc 'Alias (kubernetes:jobs:get_jobs[namespace])'
task :k8s_get_jobs, [:namespace, :verbose] do |_task, args|
  Rake::Task['kubernetes:jobs:get_jobs'].invoke(args[:namespace], args[:verbose])
end
