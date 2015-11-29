# encoding: utf-8
require 'forwardable'
require 'petrovich/value'
require 'petrovich/inflector'
require 'petrovich/inflected'
require 'petrovich/gender'
require 'petrovich/unicode'
require 'petrovich/rule_set'
require 'petrovich/case/rule'
require 'petrovich/case/rule/modifier'
require 'petrovich/case/rule/test'
require 'petrovich/gender/rule'

# A library to inflect Russian anthroponyms such as first names, last names, and middle names.
module Petrovich
  # Possible cases
  CASES = [
    :nominative,
    :genitive,
    :dative,
    :accusative,
    :instrumental,
    :prepositional
  ]

  class << self
    # A place that keeps inflection and gender rules loaded from yaml file.
    #
    # @return Petrovich::RuleSet
    attr_accessor :rule_set

    # Checks name that should be value object, instance of {Petrovich::Value}
    #
    # Raises an ArgumentError if passed argument not of type Petrovich::Value or
    # all values is empty in this object.
    #
    # @example
    #   Petrovich.assert_name!(name)
    #
    # @param [Foo] name Value to check
    def assert_name!(name)
      unless name.is_a?(Value)
        fail ArgumentError, 'Passed argument should be Petrovich::Value instace'.freeze
      end

      if [name.lastname, name.firstname, name.middlename].compact.size == 0
        fail ArgumentError, 'You should set at least one of :lastname, :firstname or :middlename'.freeze
      end
    end

    # Checks passed argument that should be member of {CASES}
    #
    # Raises an ArgumentError if passed argument not in {CASES}
    #
    # @example
    #   Petrovich.assert_case!(name_case)
    #
    # @param [Foo] name_case Value to check
    def assert_case!(name_case)
      return if CASES.include?(name_case)
      fail ArgumentError, "Unknown case #{name_case}"
    end

    # Converts hash to {Petrovich::Value} value object
    #
    # @example
    #   Petrovich.normalize_name(firstname: 'Иван', lastname: 'Иванов')
    #
    # @param [Hash] name Value hash with lastname, firstname, middlename
    # @return [Petrovich::Value] Value object
    def normalize_name(name)
      name = Value.new(name) if name.is_a?(Hash)
      name
    end

    # Loads YAML rules into {Petrovich::RuleSet} object
    # @return [void]
    def load_rules!
      self.rule_set ||= RuleSet.new
      self.rule_set.load!
    end
  end

  load_rules!

  require 'petrovich/name'
end

# Main entry point
def Petrovich(opts)
  Petrovich::Name.new(opts)
end
