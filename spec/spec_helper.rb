# encoding: utf-8

require 'rubygems'
require 'bundler/setup'
require 'minitest/autorun'

begin
  require 'petrovich'
rescue Errno::ENOENT => e
  warn 'WARNING! Please, run `git submodule update --init --recursive` to populate petrovich-rules submodule' if e.message.index('rules.yml')
  raise
end

class MiniTest::Spec
  class << self
    alias :context :describe
  end
end
