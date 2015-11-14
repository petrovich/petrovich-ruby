# encoding: utf-8

begin
  require 'minitest/autorun'
  require 'minitest/reporters'

  Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

  require 'petrovich'
rescue Errno::ENOENT => e
  warn 'WARNING! Please, run `git submodule update --init --recursive` to populate petrovich-rules submodule' if e.message.index('rules.yml')
  raise
end
