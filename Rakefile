#!/usr/bin/env rake

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:chefspec)

require 'cookstyle'
require 'rubocop/rake_task'
RuboCop::RakeTask.new(:cookstyle)

begin
  require 'kitchen/rake_tasks'
  Kitchen::RakeTasks.new
rescue
  puts '>>> Kitchen gem not loaded, omitting tasks' unless ENV['CI']
end

task default: %w(cookstyle chefspec)
task all: %w(default kitchen:all)
