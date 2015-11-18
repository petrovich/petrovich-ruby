# encoding: utf-8
require 'ostruct'
require 'yaml'
require 'petrovich/inflector'
require 'petrovich/inflected'
require 'petrovich/gender_methods'
require 'petrovich/scan_methods'
require 'petrovich/unicode'
require 'petrovich/rule_set'
require 'petrovich/rule'
require 'petrovich/rule/modifier'
require 'petrovich/rule/test'

module Petrovich
  # Набор правил
  @@rule_set = RuleSet.new

  include Unicode

  CASE_NOMINATIVE    = :nominative    # именительный
  CASE_GENITIVE      = :genitive      # родительный
  CASE_DATIVE        = :dative        # дательный
  CASE_ACCUSATIVE    = :accusative    # винительный
  CASE_INSTRUMENTAL  = :instrumental  # творительный
  CASE_PREPOSITIONAL = :prepositional # предложный

  CASES = [
    CASE_NOMINATIVE, CASE_GENITIVE, CASE_DATIVE,
    CASE_ACCUSATIVE, CASE_INSTRUMENTAL, CASE_PREPOSITIONAL
  ]

  UnknownCaseError = Class.new(StandardError)
  UnknownRuleError = Class.new(StandardError)
  ApplyRuleError   = Class.new(StandardError)

  def self.add_rule(rule)
    @@rule_set.add(rule)
  end

  def self.clear_rules!
    @@rule_set.clear!
  end

  def self.load_rules!
    @@rule_set.load!
  end

  def self.inflect(name, gender, name_case)
    inflector = Inflector.new(name, gender, name_case)

    if !name.lastname.nil? && (rules = @@rule_set.find_all(name.lastname, gender, :lastname))
      name.lastname = inflector.inflect_lastname(rules)
    end

    if !name.firstname.nil? && (rules = @@rule_set.find_all(name.firstname, gender, :firstname))
      name.firstname = inflector.inflect_firstname(rules)
    end

    if !name.middlename.nil? && (rules = @@rule_set.find_all(name.middlename, gender, :middlename))
      name.middlename = inflector.inflect_middlename(rules)
    end

    name
  end

  require 'petrovich/name'
end

def Petrovich(opts)
  Petrovich.load_rules!
  Petrovich::Name.new(opts)
end
