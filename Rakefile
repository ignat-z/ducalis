# frozen_string_literal: true

require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RuboCop::RakeTask.new do |task|
  task.options = ['--auto-correct']
end

task :documentation do
  require './lib/documentation'
  File.write('DOCUMENTATION.md', Documentation.new.call)
end

RSpec::Core::RakeTask.new(:spec)
task default: %i[rubocop spec]
