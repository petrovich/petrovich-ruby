#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end
begin
  require 'rdoc/task'
rescue LoadError
  require 'rdoc/rdoc'
  require 'rake/rdoctask'
  RDoc::Task = Rake::RDocTask
end

task :petrovich do
  require 'petrovich'
end

Dir.glob('lib/tasks/*.rake').each { |r| import r }

# Run tests and perform evaluation by default
task :default => [:spec, :evaluate]

Bundler::GemHelper.install_tasks
