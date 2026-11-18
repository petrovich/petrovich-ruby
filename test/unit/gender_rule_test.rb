# encoding: utf-8
require_relative '../test_helper'

describe Petrovich::Gender::Rule do
  def build_rule(gender = :male, as = :firstname, suffix = 'ов')
    Petrovich::Gender::Rule.new(gender: gender, as: as, suffix: suffix)
  end

  it 'keeps the gender and the name part' do
    rule = build_rule(:female, :lastname)

    assert_equal :female, rule.gender
    assert_equal :lastname, rule.as
  end

  it 'builds a case-insensitive suffix regexp anchored at the end' do
    rule = build_rule

    assert_instance_of Regexp, rule.suffix
    assert_equal 'ов$', rule.suffix.source
    assert((rule.suffix.options & Regexp::IGNORECASE) != 0)
  end

  it 'calculates accuracy from the source suffix' do
    assert_equal 2, build_rule(:male, :firstname, 'ов').accuracy
    assert_equal 4, build_rule(:female, :lastname, 'ская').accuracy
  end

  it 'matches names with the suffix' do
    assert_equal true, build_rule.match?('Иванов')
  end

  it 'does not match names with another suffix' do
    assert_equal false, build_rule.match?('Иван')
  end

  it 'ignores the case of the name' do
    assert_equal true, build_rule.match?('ИВАНОВ')
  end
end
