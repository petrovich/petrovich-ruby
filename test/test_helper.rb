# encoding: utf-8

require 'rubygems'

gem 'minitest'
require 'minitest/autorun'

begin
  require 'petrovich'
rescue Errno::ENOENT => e
  if e.message =~ /rules\.yml|gender\.yml/
    abort 'Please, run `git submodule update --init --recursive` to populate the submodules.'
  end

  raise
end
