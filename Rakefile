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
Dir.glob('tasks/**/*.rb').each do |file|
  require_relative file.gsub('.rb', '')
end

# Load all Rake Task Files
Dir.glob('tasks/**/*.rake').each do |task_file|
  load task_file
end

# Default Rake Task (rake <enter>)
# TODO: Find better solution to run rubocop without all the env var requirements. Not just for CI, but IDE console that doesn't auto load shell profiles etc.
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
