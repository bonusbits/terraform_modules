$VERBOSE = nil

# For CircleCI
require 'bundler/setup'

# For Rake Tasks
require 'colorize'
require 'deep_merge'
require 'fileutils'
require 'highline/import'
require 'rubocop-rake'

# Load Rake Task Helper Methods
lib_dir_list = %w[
  tasks/lib/*.rb
  tasks/aws/lib/*.rb
  tasks/bastion/lib/*.rb
  tasks/bonusbits/lib/*.rb
  tasks/helm/lib/*.rb
  tasks/kubernetes/lib/*.rb
  tasks/orchestrator/lib/*.rb
  tasks/packer/lib/*.rb
  tasks/packages/lib/*.rb
  tasks/secrets/lib/*.rb
  tasks/terraform/lib/*.rb
  tasks/web/lib/*.rb
]
lib_dir_list.each do |dir|
  Dir.glob(dir).each do |file|
    require_relative file.gsub('.rb', '')
  end
end

# Load all Rake Task Files
rake_dir_list = %w[
  tasks/*.rake
  tasks/aws/*.rake
  tasks/bastion/*.rake
  tasks/bonusbits/*.rake
  tasks/helm/*.rake
  tasks/kubernetes/*.rake
  tasks/orchestrator/*.rake
  tasks/packer/*.rake
  tasks/packages/*.rake
  tasks/secrets/*.rake
  tasks/terraform/*.rake
  tasks/test/*.rake
  tasks/web/*.rake
]
rake_dir_list.each do |dir|
  Dir.glob(dir).each do |task_file|
    load task_file
  end
end

# Default Rake Task (rake <enter>)
desc 'Alias (test:style:ruby:auto_correct)'
task default: %w[test:style:ruby:auto_correct]

# Defaults using Environment Variables or Defaults that can be overridden
$project_vars = Hash.new
$project_vars['orchestrator'] = Hash.new
$project_vars['orchestrator']['orchestrator_path'] =
  if ENV['CI']
    Dir.getwd
  else
    ENV.fetch('BB_ORCHESTRATOR_PATH', Dir.getwd)
  end
$header_count = 0
Orchestrator::Vars.env_vars
Orchestrator::Vars.yaml_vars
# load_yaml_vars creates the hash value needed for debug
$debug = $project_vars['orchestrator']['feature_toggles']['debug']
