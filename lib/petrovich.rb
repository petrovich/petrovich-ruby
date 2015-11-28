# encoding: utf-8
require 'ostruct'
require 'forwardable'
require 'yaml'
require 'petrovich/inflector'
require 'petrovich/inflected'
require 'petrovich/gender'
require 'petrovich/unicode'
require 'petrovich/rule_set'
require 'petrovich/case/rule'
require 'petrovich/case/rule/modifier'
require 'petrovich/case/rule/test'
require 'petrovich/gender/rule'

module Petrovich
  CASES = [
    :nominative,   # именительный
    :genitive,     # родительный
    :dative,       # дательный
    :accusative,   # винительный
    :instrumental, # творительный
    :prepositional # предложный
  ]

  class << self
    # A set of rules
    attr_accessor :rule_set

    def assert_name!(name)
      unless name.respond_to?(:lastname) || name.respond_to?(:firstname) || name.respond_to?(:middlename)
        raise ArgumentError, "You should pass at least one of :lastname, :firstname or :middlename keys".freeze
      end
    end

    def assert_case!(name_case)
      unless CASES.include?(name_case)
        raise ArgumentError, "Unknown case #{name_case}"
      end
    end

    def normalize_name(name)
      name = OpenStruct.new(name) if name.is_a?(Hash)

      [:lastname, :firstname, :middlename].each do |name_part|
        if name.respond_to?(name_part) && name.send(name_part).nil?
          name.delete_field(name_part)
        end
      end

      name
    end

    def load_rules!
      self.rule_set ||= RuleSet.new
      self.rule_set.load!
    end
  end

  load_rules!

  require 'petrovich/name'
end

def Petrovich(opts)
  Petrovich::Name.new(opts)
end
