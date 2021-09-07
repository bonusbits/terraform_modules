namespace :test do
  # Style test. Rubocop
  namespace :style do
    require 'rubocop/rake_task'

    desc 'RuboCop'
    RuboCop::RakeTask.new(:ruby) do |task|
      task.options << '--display-cop-names'
    end
  end
end

desc 'Alias (test:style:ruby)'
task test_style: %w[test:style:ruby]
