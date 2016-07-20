# encoding: utf-8

require 'rubygems'

gem 'minitest'
require 'minitest/autorun'

begin
  require 'petrovich'
rescue Errno::ENOENT => e
  if e.message.index('rules.yml') || e.message.index('gender.yml')
    warn 'Please, run `git submodule update --init --recursive` to populate the submodules.'
  end
end
