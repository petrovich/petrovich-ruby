# encoding: utf-8
require_relative 'test_helper'

describe Petrovich do
  it 'builds a Name from options' do
    name = Petrovich(lastname: 'Иванов', firstname: 'Иван')

    assert_instance_of Petrovich::Name, name
    assert_equal 'Иванов', name.lastname
    assert_equal 'Иван', name.firstname
  end

  it 'accepts a value with at least one name part' do
    value = Petrovich::Value.new(firstname: 'Иван')

    assert_nil Petrovich.assert_name!(value)
  end

  it 'rejects a non-value object' do
    assert_raises(ArgumentError) do
      Petrovich.assert_name!('Иван')
    end
  end

  it 'rejects a value without name parts' do
    assert_raises(ArgumentError) do
      Petrovich.assert_name!(Petrovich::Value.new({}))
    end
  end

  it 'accepts every known case' do
    Petrovich::CASES.each do |name_case|
      assert_nil Petrovich.assert_case!(name_case)
    end
  end

  it 'rejects an unknown case' do
    assert_raises(ArgumentError) do
      Petrovich.assert_case!(:bogus)
    end
  end

  it 'normalizes a hash to a value' do
    value = Petrovich.normalize_name(lastname: 'Иванов', firstname: 'Иван')

    assert_instance_of Petrovich::Value, value
    assert_equal 'Иванов', value.lastname
    assert_equal 'Иван', value.firstname
    assert_nil value.middlename
  end

  it 'returns a value unchanged' do
    value = Petrovich::Value.new(firstname: 'Иван')

    assert_same value, Petrovich.normalize_name(value)
  end

  it 'returns arbitrary objects unchanged' do
    object = Object.new

    assert_same object, Petrovich.normalize_name(object)
  end

  it 'does not load rules twice' do
    count = Petrovich.rule_set.instance_variable_get(:@case_rules).size

    assert_equal false, Petrovich.load_rules!
    assert_equal count, Petrovich.rule_set.instance_variable_get(:@case_rules).size
  end

  it 'loads rules when the rule set does not exist yet' do
    original_rule_set = Petrovich.rule_set
    count = original_rule_set.instance_variable_get(:@case_rules).size

    begin
      Petrovich.rule_set = nil

      result = Petrovich.load_rules!

      refute_nil Petrovich.rule_set
      refute_equal false, result
      assert_equal count, Petrovich.rule_set.instance_variable_get(:@case_rules).size
    ensure
      Petrovich.rule_set = original_rule_set
    end

    assert_same original_rule_set, Petrovich.rule_set
  end

  it 'has a semantic version' do
    assert_match(/\A\d+\.\d+\.\d+\z/, Petrovich::VERSION)
  end
end
