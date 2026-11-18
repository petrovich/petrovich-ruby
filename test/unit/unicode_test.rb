# encoding: utf-8
require_relative '../test_helper'

describe Petrovich::Unicode do
  it 'downcases Russian text' do
    assert_equal 'ёжик', Petrovich::Unicode.downcase('ЁЖИК')
  end

  it 'upcases Russian text' do
    assert_equal 'ЁЖИК', Petrovich::Unicode.upcase('ёжик')
  end

  it 'treats nil as an empty string' do
    assert_equal '', Petrovich::Unicode.downcase(nil)
    assert_equal '', Petrovich::Unicode.upcase(nil)
  end

  it 'leaves Latin text unchanged' do
    assert_equal 'Hello World', Petrovich::Unicode.downcase('Hello World')
    assert_equal 'Hello World', Petrovich::Unicode.upcase('Hello World')
  end

  it 'is idempotent' do
    assert_equal 'ёжик', Petrovich::Unicode.downcase(Petrovich::Unicode.downcase('ЁЖИК'))
    assert_equal 'ЁЖИК', Petrovich::Unicode.upcase(Petrovich::Unicode.upcase('ёжик'))
  end

  it 'converts the full Russian alphabet' do
    assert_equal Petrovich::Unicode::RU_LOWER,
                 Petrovich::Unicode.downcase(Petrovich::Unicode::RU_UPPER)
    assert_equal Petrovich::Unicode::RU_UPPER,
                 Petrovich::Unicode.upcase(Petrovich::Unicode::RU_LOWER)
    assert_equal 33, Petrovich::Unicode::RU_UPPER.length
    assert_equal 33, Petrovich::Unicode::RU_LOWER.length
  end
end
