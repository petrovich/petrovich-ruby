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

require 'rake/testtask'
Rake::TestTask.new(:spec) do |test|
  test.libs << 'spec'
  test.test_files = Dir['spec/**/*_spec.rb']
  test.verbose = true
end

task :petrovich do
  require 'petrovich'
end

# Run tests and perform evaluation by default
task :default => [:spec, :evaluate]

Dir.glob('lib/tasks/*.rake').each { |r| import r }
