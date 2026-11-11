# encoding: utf-8
require_relative '../test_helper'

describe Petrovich::Inflector do
  def build_rule(modifier, name_case = :genitive, as = :firstname)
    modifiers = Array.new(5)
    modifiers[Petrovich::CASES.index(name_case) - 1] = modifier

    Petrovich::Case::Rule.new(
      gender: :male,
      as: as,
      modifiers: modifiers,
      tests: []
    )
  end

  it 'accepts a hash as a name' do
    inflector = Petrovich::Inflector.new({ firstname: 'Иван' }, :male, :dative)

    assert_equal 'Иван', inflector.inflect_firstname([])
  end

  it 'fails on an empty value' do
    assert_raises(ArgumentError) do
      Petrovich::Inflector.new(Petrovich::Value.new({}), :male, :dative)
    end
  end

  it 'returns name parts unchanged when there are no rules' do
    inflector = Petrovich::Inflector.new({
      lastname: 'Иванов',
      firstname: 'Иван',
      middlename: 'Иванович'
    }, :male, :dative)

    assert_equal 'Иванов', inflector.inflect_lastname([])
    assert_equal 'Иван', inflector.inflect_firstname([])
    assert_equal 'Иванович', inflector.inflect_middlename([])
  end

  it 'does not change a name part in the nominative case' do
    inflector = Petrovich::Inflector.new({ firstname: 'Иван' }, :male, :nominative)
    rule = build_rule(Petrovich::Case::Rule::Modifier.new('а', 0), :nominative)

    assert_equal 'Иван', inflector.inflect_firstname([rule])
  end

  it 'adds a suffix when the offset is zero' do
    inflector = Petrovich::Inflector.new({ firstname: 'Иван' }, :male, :genitive)
    rule = build_rule(Petrovich::Case::Rule::Modifier.new('а', 0))

    assert_equal 'Ивана', inflector.inflect_firstname([rule])
  end

  it 'replaces the ending when the offset is positive' do
    inflector = Petrovich::Inflector.new({ firstname: 'Иванов' }, :male, :genitive)
    rule = build_rule(Petrovich::Case::Rule::Modifier.new('у', 2))

    assert_equal 'Ивану', inflector.inflect_firstname([rule])
  end

  it 'inflects every part of a hyphenated name' do
    inflector = Petrovich::Inflector.new({ lastname: 'Салтыков-Щедрин' }, :male, :genitive)
    modifier = Petrovich::Case::Rule::Modifier.new('у', 0)
    rules = [
      build_rule(modifier, :genitive, :lastname),
      build_rule(modifier, :genitive, :lastname)
    ]

    assert_equal 'Салтыкову-Щедрину', inflector.inflect_lastname(rules)
  end

  it 'leaves parts without rules unchanged' do
    inflector = Petrovich::Inflector.new({ lastname: 'Салтыков-Щедрин-Третий' }, :male, :genitive)
    modifier = Petrovich::Case::Rule::Modifier.new('у', 0)
    rules = [
      build_rule(modifier, :genitive, :lastname),
      build_rule(modifier, :genitive, :lastname)
    ]

    assert_equal 'Салтыкову-Щедрину-Третий', inflector.inflect_lastname(rules)
  end

  it 'leaves a part unchanged when its rule is nil' do
    inflector = Petrovich::Inflector.new({ lastname: 'Петров' }, :male, :genitive)

    assert_equal 'Петров', inflector.inflect_lastname([nil])
  end

  it 'inflects first names and middle names' do
    inflector = Petrovich::Inflector.new({
      firstname: 'Иван',
      middlename: 'Иванович'
    }, :male, :genitive)

    assert_equal 'Ивана', inflector.inflect_firstname([
      build_rule(Petrovich::Case::Rule::Modifier.new('а', 0), :genitive, :firstname)
    ])
    assert_equal 'Ивановича', inflector.inflect_middlename([
      build_rule(Petrovich::Case::Rule::Modifier.new('а', 0), :genitive, :middlename)
    ])
  end

  it 'consumes the rules array' do
    inflector = Petrovich::Inflector.new({ lastname: 'Салтыков-Щедрин' }, :male, :genitive)
    modifier = Petrovich::Case::Rule::Modifier.new('у', 0)
    rules = [
      build_rule(modifier, :genitive, :lastname),
      build_rule(modifier, :genitive, :lastname)
    ]

    inflector.inflect_lastname(rules)

    assert_empty rules
  end
end
