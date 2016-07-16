#!/usr/bin/env rake
# encoding: utf-8

require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new do |t|
  t.test_files = FileList['test/*_test.rb']
end

task default: :test

# We need this to avoid loading the library in tasks directly.
task :petrovich do
  require 'petrovich'
end

Rake::TestTask.new(:bench) do |test|
  test.libs << 'test'
  test.test_files = Dir['test/**/bench_*.rb']
end

Dir.glob('lib/tasks/*.rake').each { |r| import r }
