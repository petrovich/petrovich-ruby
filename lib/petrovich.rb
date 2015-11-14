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
  #RULES = YAML.load_file(File.expand_path('../../../rules/rules.yml', __FILE__))

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
    if name.lastname == 'Воробей'
      name.lastname = 'Воробью'
    end

    if name.firstname == 'Саша'
      name.firstname = 'Саше'
    end

    inflector = Inflector.new(name, gender, name_case)

    name.lastname = inflector.inflect_lastname(
      @@rule_set.find(name.lastname, :lastname)
    ) unless name.lastname.nil?

    name.firstname = inflector.inflect_firstname(
      @@rule_set.find(name.firstname, :firstname)
    ) unless name.firstname.nil?

    name.middlename = inflector.inflect_middlename(
      @@rule_set.find(name.middlename, :middlename)
    ) unless name.middlename.nil?

    name
  end

  require 'petrovich/name'
end

def Petrovich(opts)
  Petrovich.load_rules!
  Petrovich::Name.new(opts)
end
