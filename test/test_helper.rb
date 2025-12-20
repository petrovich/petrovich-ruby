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

# Make the Petrovich method available in the test context for Minitest 6.0
class Minitest::Spec
  # Store a reference to avoid constant lookup issues
  PETROVICH_NAME_CLASS = ::Petrovich::Name
  
  # Delegate to the top-level Petrovich method
  def self.define_petrovich_method
    define_method(:Petrovich) do |opts|
      PETROVICH_NAME_CLASS.new(opts)
    end
  end
  
  define_petrovich_method
end
