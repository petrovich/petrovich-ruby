# encoding: utf-8
require_relative '../test_helper'

describe Petrovich::RuleSet do
  def build_case_rule(gender = :male, as = :firstname, suffixes = ['ан'], tags = [])
    tests = suffixes.map { |suffix| Petrovich::Case::Rule::Test.new(suffix) }

    Petrovich::Case::Rule.new(
      gender: gender,
      as: as,
      section: :suffixes,
      modifiers: [],
      tests: tests,
      tags: tags
    )
  end

  # A rule that records every match? call as [name, gender, context_tags]
  # and answers with the given block.
  def context_recording_rule(&matcher)
    recording_rule = Class.new(Petrovich::Case::Rule) do
      attr_reader :calls
      attr_accessor :matcher

      def initialize(opts)
        super
        @calls = []
      end

      def match?(name, match_gender, _match_as, _known_gender = false, context_tags = [])
        @calls << [name, match_gender, context_tags]
        matcher.call(match_gender)
      end
    end

    rule = recording_rule.new(gender: :androgynous, as: :lastname, modifiers: [], tests: [])
    rule.matcher = matcher || ->(_match_gender) { true }
    rule
  end

  def case_rules(rule_set)
    rule_set.instance_variable_get(:@case_rules)
  end

  def gender_rules(rule_set)
    rule_set.instance_variable_get(:@gender_rules)
  end

  it 'adds case rules' do
    rule_set = Petrovich::RuleSet.new
    rule = build_case_rule

    rule_set.add_case_rule(rule)

    assert_equal [rule], case_rules(rule_set)
  end

  it 'rejects rules of another type' do
    assert_raises(ArgumentError) do
      Petrovich::RuleSet.new.add_case_rule(Object.new)
    end
  end

  it 'loads the first_word section between exceptions and suffixes' do
    entry = ->(test) { { 'gender' => 'androgynous', 'test' => [test], 'mods' => %w[. . . . .] } }
    rules = {
      'lastname' => {},
      'firstname' => {
        'suffixes' => [entry.call('ан')],
        'first_word' => [entry.call('').merge('tags' => ['first_word'])],
        'exceptions' => [entry.call('жан')]
      },
      'middlename' => {}
    }

    rule_set = Petrovich::RuleSet.new
    rule_set.send(:load_case_rules!, rules)
    loaded = case_rules(rule_set)

    assert_equal [true, false, false], loaded.map(&:an_exception?)
    assert_equal [[], ['first_word'], []], loaded.map(&:tags)
    assert_equal true, loaded[1].match?('Пьер', :male, :firstname, false, ['first_word'])
    assert_equal false, loaded[1].match?('Пьер', :male, :firstname, false, [])
  end

  it 'clears all loaded rules' do
    rule_set = Petrovich::RuleSet.new
    rule_set.load!

    refute_empty case_rules(rule_set)
    refute_empty gender_rules(rule_set)

    rule_set.clear!

    assert_empty case_rules(rule_set)
    assert_empty gender_rules(rule_set)
    assert_empty rule_set.instance_variable_get(:@gender_exceptions)
  end

  it 'finds a rule for every part of a hyphenated name' do
    recording_rule = Class.new(Petrovich::Case::Rule) do
      def match?(_name, _match_gender, _match_as, _known_gender = false, _context_tags = [])
        true
      end
    end
    rule = recording_rule.new(gender: :male, as: :lastname, modifiers: [], tests: [])
    rule_set = Petrovich::RuleSet.new
    rule_set.add_case_rule(rule)

    found = rule_set.find_all_case_rules('Салтыков-Щедрин-Третий', :male, :lastname)

    assert_equal 3, found.size
    found.each { |found_rule| assert_same rule, found_rule }
  end

  it 'passes known_gender only for the last part of a hyphenated name' do
    recording_rule = Class.new(Petrovich::Case::Rule) do
      attr_reader :known_gender_args

      def initialize(opts)
        super
        @known_gender_args = []
      end

      def match?(_name, _match_gender, _match_as, known_gender = false, _context_tags = [])
        @known_gender_args << known_gender
        true
      end
    end
    rule = recording_rule.new(gender: :male, as: :lastname, modifiers: [], tests: [])
    rule_set = Petrovich::RuleSet.new
    rule_set.add_case_rule(rule)

    rule_set.find_all_case_rules('Иванов-Петров', :male, :lastname, true)

    assert_equal [false, true], rule.known_gender_args
  end

  # B-01: the first_word context (docs/testing-plan.md, T-30).
  it 'passes the first_word context to the first part of a two-part name only' do
    rule = context_recording_rule
    rule_set = Petrovich::RuleSet.new
    rule_set.add_case_rule(rule)

    rule_set.find_all_case_rules('Иванов-Петров', :male, :lastname)

    assert_equal [['first_word'], []], rule.calls.map(&:last)
  end

  it 'passes the first_word context to every part but the last one' do
    rule = context_recording_rule
    rule_set = Petrovich::RuleSet.new
    rule_set.add_case_rule(rule)

    rule_set.find_all_case_rules('Иванов-Бонч-Бруевич', :male, :lastname)

    assert_equal [['first_word'], ['first_word'], []], rule.calls.map(&:last)
  end

  it 'passes an empty context for a single-word name' do
    rule = context_recording_rule
    rule_set = Petrovich::RuleSet.new
    rule_set.add_case_rule(rule)

    rule_set.find_all_case_rules('Иванов', :male, :lastname)

    assert_equal [[]], rule.calls.map(&:last)
  end

  it 'passes the same context to the androgynous fallback' do
    rule = context_recording_rule { |match_gender| match_gender == :androgynous }
    rule_set = Petrovich::RuleSet.new
    rule_set.add_case_rule(rule)

    found = rule_set.find_all_case_rules('Иванов-Петров', :female, :lastname)

    assert_equal [rule, rule], found
    assert_equal [
      ['Иванов', :female, ['first_word']],
      ['Иванов', :androgynous, ['first_word']],
      ['Петров', :female, []],
      ['Петров', :androgynous, []]
    ], rule.calls
  end

  it 'finds a first_word rule for every part but the last one' do
    tagged_rule = build_case_rule(:androgynous, :lastname, ['^бонч'], ['first_word'])
    rule_set = Petrovich::RuleSet.new
    rule_set.add_case_rule(tagged_rule)

    assert_equal [tagged_rule, nil], rule_set.find_all_case_rules('Бонч-Бруевич', :male, :lastname)
    assert_equal [nil, tagged_rule, nil], rule_set.find_all_case_rules('Иванов-Бонч-Бруевич', :male, :lastname)
    assert_equal [nil, nil], rule_set.find_all_case_rules('Иванов-Бонч', :male, :lastname)
    assert_equal [nil], rule_set.find_all_case_rules('Бонч', :male, :lastname)
  end

  it 'finds a first_word rule through the androgynous fallback' do
    tagged_rule = build_case_rule(:androgynous, :lastname, ['^бонч'], ['first_word'])
    rule_set = Petrovich::RuleSet.new
    rule_set.add_case_rule(tagged_rule)

    assert_equal [tagged_rule, nil], rule_set.find_all_case_rules('Бонч-Бруевич', :female, :lastname)
    assert_equal [nil], rule_set.find_all_case_rules('Бонч', :female, :lastname)
  end

  it 'falls back to an androgynous rule when there is no rule for a known gender' do
    male_rule = build_case_rule(:male, :firstname, ['ов'])
    androgynous_rule = build_case_rule(:androgynous, :firstname, ['ан'])
    rule_set = Petrovich::RuleSet.new
    rule_set.add_case_rule(male_rule)
    rule_set.add_case_rule(androgynous_rule)

    found = rule_set.find_all_case_rules('Иван', :female, :firstname, true)

    assert_equal 1, found.size
    assert_same androgynous_rule, found.first
  end

  it 'finds gender rules for every part of a hyphenated name' do
    rule_set = Petrovich::RuleSet.new
    rule_set.load!

    found = rule_set.find_all_gender_rules('Анна-Мария', :firstname)

    assert_equal 2, found.size
    assert_equal [:female, :female], found.map(&:gender)
  end

  it 'finds a gender exception ignoring the case' do
    rule_set = Petrovich::RuleSet.new
    rule_set.load!

    rule = rule_set.send(:find_gender_rule, 'БОВА', :lastname)

    assert_equal :androgynous, rule.gender
  end

  it 'loads a case rule entry with modifiers, tests and tags' do
    entry = {
      'gender' => 'male',
      'test' => ['ов'],
      'mods' => ['.', '-а', '--ю', '---а', '----ом'],
      'tags' => ['first_word']
    }
    rule_set = Petrovich::RuleSet.new

    rule_set.send(:load_case_entry, :lastname, :suffixes, entry)

    rule = case_rules(rule_set).first
    assert_equal [['', 0], ['а', 1], ['ю', 2], ['а', 3], ['ом', 4]],
                 rule.modifiers.map { |modifier| [modifier.suffix, modifier.offset] }
    assert_equal ['first_word'], rule.tags
    assert_equal 'ов$', rule.tests.first.suffix.source
    assert_equal false, rule.an_exception?
  end

  it 'anchors exception tests to the beginning of a name' do
    entry = {
      'gender' => 'male',
      'test' => ['ов'],
      'mods' => ['.', '.', '.', '.', '.']
    }
    rule_set = Petrovich::RuleSet.new

    rule_set.send(:load_case_entry, :lastname, :exceptions, entry)

    rule = case_rules(rule_set).first
    assert_equal '^ов$', rule.tests.first.suffix.source
    assert_equal true, rule.an_exception?
  end

  it 'loads a gender rule entry' do
    rule_set = Petrovich::RuleSet.new

    rule_set.send(:load_gender_entry, :firstname, :male, 'ов')

    rule = gender_rules(rule_set)[:firstname].first
    assert_equal :male, rule.gender
    assert_equal :firstname, rule.as
    assert_equal 2, rule.accuracy
    assert_equal true, rule.match?('Иванов')
    assert_equal true, rule.match?('ИВАНОВ')
    assert_equal false, rule.match?('Иван')
  end

  it 'does not load rules twice' do
    rule_set = Petrovich::RuleSet.new

    refute_equal false, rule_set.load!
    count = case_rules(rule_set).size
    assert_operator count, :>, 0

    assert_equal false, rule_set.load!
    assert_equal count, case_rules(rule_set).size
  end

  it 'sorts gender rules by accuracy after loading' do
    rule_set = Petrovich::RuleSet.new
    rule_set.load!

    gender_rules(rule_set).each_value do |rules|
      assert rules.each_cons(2).all? { |left, right| left.accuracy >= right.accuracy }
    end
  end

  it 'loads rules again after clearing' do
    rule_set = Petrovich::RuleSet.new
    rule_set.load!
    count = case_rules(rule_set).size

    rule_set.clear!
    assert_empty case_rules(rule_set)

    refute_equal false, rule_set.load!
    assert_equal count, case_rules(rule_set).size
  end

  # B-05: words separated by spaces (docs/compound-surnames-plan.md, T-39).
  it 'splits a name by spaces and passes first_word to every word but the last' do
    rule = context_recording_rule
    rule_set = Petrovich::RuleSet.new
    rule_set.add_case_rule(rule)

    found = rule_set.find_all_case_rules('Роналду душ Сантуш Авейру', :male, :lastname)

    assert_equal 4, found.size
    assert_equal %w[Роналду душ Сантуш Авейру], rule.calls.map(&:first)
    assert_equal [['first_word'], ['first_word'], ['first_word'], []], rule.calls.map(&:last)
  end

  it 'splits a name by spaces and hyphens together' do
    rule = context_recording_rule
    rule_set = Petrovich::RuleSet.new
    rule_set.add_case_rule(rule)

    rule_set.find_all_case_rules('де Сент-Экзюпери', :male, :lastname)

    assert_equal %w[де Сент Экзюпери], rule.calls.map(&:first)
  end
end
