# encoding: utf-8
require_relative '../test_helper'

describe Petrovich::Case::Rule::Modifier do
  it 'converts a suffix to a string' do
    assert_equal 'а', Petrovich::Case::Rule::Modifier.new(:а).suffix
  end

  it 'defaults the offset to zero' do
    assert_equal 0, Petrovich::Case::Rule::Modifier.new('а').offset
  end

  it 'accepts a custom offset' do
    modifier = Petrovich::Case::Rule::Modifier.new('ому', 2)

    assert_equal 'ому', modifier.suffix
    assert_equal 2, modifier.offset
  end

  it 'inspects as a suffix and offset array' do
    modifier = Petrovich::Case::Rule::Modifier.new('а', 2)

    assert_equal ['а', 2].inspect, modifier.inspect
  end
end
