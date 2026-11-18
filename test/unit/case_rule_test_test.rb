# encoding: utf-8
require_relative '../test_helper'

describe Petrovich::Case::Rule::Test do
  def build_test(suffix)
    Petrovich::Case::Rule::Test.new(suffix)
  end

  it 'builds a case-insensitive suffix regexp anchored at the end' do
    test = build_test('ов')

    assert_instance_of Regexp, test.suffix
    assert_equal 'ов$', test.suffix.source
    assert((test.suffix.options & Regexp::IGNORECASE) != 0)
  end

  it 'matches names with the suffix' do
    assert_equal true, build_test('ов').match?('Иванов')
  end

  it 'does not match names with another suffix' do
    assert_equal false, build_test('ов').match?('Иван')
  end

  it 'ignores the case of the name' do
    assert_equal true, build_test('ов').match?('ИВАНОВ')
  end

  it 'inspects as its suffix' do
    test = build_test('ов')

    assert_equal test.suffix.inspect, test.inspect
  end
end
