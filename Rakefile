#!/usr/bin/env rake
# encoding: utf-8

require 'bundler/gem_tasks'

begin
  require 'rdoc/task'
rescue LoadError
  require 'rdoc/rdoc'
  require 'rake/rdoctask'
  RDoc::Task = Rake::RDocTask
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task :petrovich do
  require 'petrovich'
end

# Run tests and perform evaluation by default
task :default => [:spec, :evaluate]

Dir.glob('lib/tasks/*.rake').each { |r| import r }
