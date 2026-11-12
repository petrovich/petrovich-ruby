# encoding: utf-8
require_relative '../test_helper'

describe Petrovich::Case::Rule do
  def build_rule(opts = {})
    defaults = {
      gender: :male,
      as: :lastname,
      section: :suffixes,
      modifiers: [],
      tests: [Petrovich::Case::Rule::Test.new('ов')],
      tags: nil
    }

    Petrovich::Case::Rule.new(defaults.merge(opts))
  end

  it 'normalizes the gender to a downcased symbol' do
    assert_equal :male, build_rule(gender: 'Male').gender
    assert_equal :female, build_rule(gender: 'FEMALE').gender
  end

  it 'keeps the name part, modifiers, tests and tags' do
    modifier = Petrovich::Case::Rule::Modifier.new('а', 2)
    test = Petrovich::Case::Rule::Test.new('ов')
    rule = build_rule(
      as: :firstname,
      modifiers: [modifier],
      tests: [test],
      tags: ['first_word']
    )

    assert_equal :firstname, rule.as
    assert_equal [modifier], rule.modifiers
    assert_equal [test], rule.tests
    assert_equal ['first_word'], rule.tags
  end

  it 'defaults tags to an empty array' do
    assert_equal [], build_rule.tags
  end

  it 'marks rules from the exceptions section as exceptional' do
    rule = build_rule(section: :exceptions)

    assert_equal true, rule.an_exception
    assert_equal true, rule.an_exception?
  end

  it 'does not mark rules from the suffixes section as exceptional' do
    rule = build_rule(section: :suffixes)

    assert_equal false, rule.an_exception
    assert_equal false, rule.an_exception?
  end

  it 'does not match another name part' do
    assert_equal false, build_rule.match?('Иванов', :male, :firstname, true)
  end

  it 'matches only its own gender when the gender is known' do
    assert_equal true, build_rule(gender: :male).match?('Иванов', :male, :lastname, true)
    assert_equal false, build_rule(gender: :male).match?('Иванов', :female, :lastname, true)
    assert_equal false, build_rule(gender: :male).match?('Иванов', :androgynous, :lastname, true)
    assert_equal false, build_rule(gender: :male).match?('Иванов', nil, :lastname, true)

    assert_equal false, build_rule(gender: :female).match?('Иванов', :male, :lastname, true)
    assert_equal true, build_rule(gender: :female).match?('Иванов', :female, :lastname, true)
    assert_equal false, build_rule(gender: :female).match?('Иванов', :androgynous, :lastname, true)
    assert_equal false, build_rule(gender: :female).match?('Иванов', nil, :lastname, true)

    assert_equal false, build_rule(gender: :androgynous).match?('Иванов', :male, :lastname, true)
    assert_equal false, build_rule(gender: :androgynous).match?('Иванов', :female, :lastname, true)
    assert_equal true, build_rule(gender: :androgynous).match?('Иванов', :androgynous, :lastname, true)
    assert_equal false, build_rule(gender: :androgynous).match?('Иванов', nil, :lastname, true)
  end

  it 'matches male and androgynous rules when the gender is unknown' do
    male_rule = build_rule(gender: :male)

    assert_equal true, male_rule.match?('Иванов', :male, :lastname)
    assert_equal false, male_rule.match?('Иванов', :female, :lastname)
    assert_equal true, male_rule.match?('Иванов', :androgynous, :lastname)
    assert_equal true, male_rule.match?('Иванов', nil, :lastname)
  end

  it 'matches only female rules when the gender is unknown' do
    female_rule = build_rule(gender: :female)

    assert_equal false, female_rule.match?('Иванов', :male, :lastname)
    assert_equal true, female_rule.match?('Иванов', :female, :lastname)
    assert_equal false, female_rule.match?('Иванов', :androgynous, :lastname)
    assert_equal false, female_rule.match?('Иванов', nil, :lastname)
  end

  it 'matches androgynous rules for any non-female unknown gender' do
    androgynous_rule = build_rule(gender: :androgynous)

    assert_equal true, androgynous_rule.match?('Иванов', :male, :lastname)
    assert_equal false, androgynous_rule.match?('Иванов', :female, :lastname)
    assert_equal true, androgynous_rule.match?('Иванов', :androgynous, :lastname)
    assert_equal true, androgynous_rule.match?('Иванов', nil, :lastname)
  end

  it 'matches the rule suffix ignoring the case' do
    rule = build_rule

    assert_equal true, rule.match?('Иванов', :male, :lastname)
    assert_equal true, rule.match?('ИВАНОВ', :male, :lastname)
    assert_equal false, rule.match?('Иван', :male, :lastname)
  end

  it 'returns nil for the nominative case' do
    assert_nil build_rule.get_modifier(:nominative)
  end

  it 'returns modifiers for the other cases' do
    modifiers = Petrovich::CASES[1..-1].each_with_index.map do |_name_case, index|
      Petrovich::Case::Rule::Modifier.new("m#{index}", index)
    end
    rule = build_rule(modifiers: modifiers)

    Petrovich::CASES[1..-1].each_with_index do |name_case, index|
      assert_same modifiers[index], rule.get_modifier(name_case)
    end
  end

  it 'accepts a case given as a string' do
    modifiers = Petrovich::CASES[1..-1].map do |_name_case|
      Petrovich::Case::Rule::Modifier.new('а', 0)
    end
    rule = build_rule(modifiers: modifiers)

    assert_same modifiers[1], rule.get_modifier('dative')
  end

  it 'fails on an unknown case' do
    assert_raises(Petrovich::UnknownCaseError) do
      build_rule.get_modifier(:bogus)
    end
  end

  # B-01: tags restrict a rule to matching context tags (docs/testing-plan.md, T-29).
  describe 'with tags' do
    def tagged_rule
      build_rule(gender: :androgynous, tags: ['first_word'])
    end

    it 'does not match a tagged rule without context tags' do
      assert_equal false, tagged_rule.match?('Иванов', :male, :lastname, false, [])
    end

    it 'matches a tagged rule when the context has its tag' do
      assert_equal true, tagged_rule.match?('Иванов', :male, :lastname, false, ['first_word'])
    end

    it 'does not match a tagged rule in another context' do
      assert_equal false, tagged_rule.match?('Иванов', :male, :lastname, false, ['second_word'])
    end

    it 'matches a tagged rule when the context is a superset of its tags' do
      assert_equal true, tagged_rule.match?('Иванов', :male, :lastname, false, %w[first_word other])
    end

    it 'matches an untagged rule in any context' do
      rule = build_rule(gender: :androgynous)

      [[], ['first_word'], ['other']].each do |context_tags|
        assert_equal true, rule.match?('Иванов', :male, :lastname, false, context_tags)
      end
    end

    it 'does not match a tagged rule called without the context argument' do
      assert_equal false, tagged_rule.match?('Иванов', :male, :lastname, false)
      assert_equal false, tagged_rule.match?('Иванов', :male, :lastname)
    end

    it 'does not match another suffix even in the matching context' do
      assert_equal false, tagged_rule.match?('Иван', :male, :lastname, false, ['first_word'])
    end
  end
end
