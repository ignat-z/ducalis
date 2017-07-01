# frozen_string_literal: true

require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RuboCop::RakeTask.new do |task|
  task.options = ['--auto-correct']
end

RSpec::Core::RakeTask.new(:spec)

default_tasks = ENV['FULL'].nil? ? %i[spec] : %i[spec rubocop]
task default: default_tasks
