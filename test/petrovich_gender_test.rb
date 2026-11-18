# encoding: utf-8
require_relative 'test_helper'

describe Petrovich::Gender do
  it 'detects male gender by firstname' do
    assert_equal :male, Petrovich(firstname: 'Александр').gender
  end

  it 'detects male gender by lastname' do
    assert_equal :male, Petrovich(lastname: 'Склифасовский').gender
  end

  it 'detects female gender by firstname' do
    assert_equal :female, Petrovich(firstname: 'Александра').gender
  end

  it 'detects female gender by lastname' do
    assert_equal :female, Petrovich(lastname: 'Склифасовская').gender
  end

  it 'detects female gender by firstname and lastname' do
    assert_equal :female, Petrovich(firstname: 'Александра', lastname: 'Склифасовская').gender
  end

  it 'detects androgynous gender by firstname' do
    assert_equal :androgynous, Petrovich(firstname: 'Саша').gender
  end

  it 'detects androgynous gender by firstname and lastname' do
    assert_equal :androgynous, Petrovich(firstname: 'Саша', lastname: 'Андрейчук').gender
  end

  it 'detects male gender by firstname and lastname' do
    assert_equal :male, Petrovich(firstname: 'Саша', lastname: 'Иванов').gender
  end

  it 'detects male gender by firstname, lastname and middlename' do
    assert_equal :male, Petrovich(firstname: 'Саша', lastname: 'Андрейчук', middlename: 'Олегович').gender
  end

  it 'detects male gender by firstname and middlename' do
    assert_equal :male, Petrovich(firstname: 'Саша', middlename: 'Олегович').gender
  end

  it 'detects androgynous gender by lastname' do
    assert_equal :androgynous, Petrovich(lastname: 'Осипчук').gender
  end

  it 'detects male gender by middlename' do
    assert_equal :male, Petrovich(middlename: 'Олегович').gender
  end

  it 'detects female gender by middlename' do
    assert_equal :female, Petrovich(middlename: 'Олеговна').gender
  end

  it 'fails with argument error test 1' do
    _ { Petrovich::Gender.detect(xxx: 'yyy') }.must_raise ArgumentError
  end

  it 'fails with argument error test 2' do
    _ { Petrovich::Gender.detect('wrong args') }.must_raise ArgumentError
  end

  it 'fails with argument error test 3' do
    _ { Petrovich::Gender.detect(firstname: nil, lastname: nil) }.must_raise ArgumentError
  end

  it 'fails with argument error for nil' do
    _ { Petrovich::Gender.detect(nil) }.must_raise ArgumentError
  end

  it 'fails with argument error for an empty hash' do
    _ { Petrovich::Gender.detect({}) }.must_raise ArgumentError
  end

  it 'accepts a value object' do
    value = Petrovich::Value.new(firstname: 'Александр')

    assert_equal :male, Petrovich::Gender.detect(value)
  end

  it 'returns nil for an empty first name' do
    assert_nil Petrovich::Gender.detect(firstname: '')
  end

  it 'prefers the first name over an androgynous last name' do
    assert_equal :male, Petrovich(firstname: 'Александр', lastname: 'Осипчук').gender
  end

  it 'prefers the last name over an androgynous first name' do
    assert_equal :female, Petrovich(firstname: 'Саша', lastname: 'Склифасовская').gender
  end

  it 'returns nil when the first name and the last name conflict' do
    assert_nil Petrovich(firstname: 'Александр', lastname: 'Склифасовская').gender
  end

  it 'prefers a middle name over conflicting name parts' do
    assert_equal :female, Petrovich(firstname: 'Александр', middlename: 'Олеговна').gender
  end

  it 'detects an exception ignoring the case' do
    assert_equal :androgynous, Petrovich(lastname: 'БОВА').gender
  end

  it 'detects gender for every part of a hyphenated first name' do
    assert_equal :female, Petrovich(firstname: 'Анна-Мария').gender
  end

  it 'uses the last part of a hyphenated last name' do
    assert_equal :androgynous, Petrovich(lastname: 'Иванов-Осипчук').gender
    assert_equal :male, Petrovich(lastname: 'Осипчук-Иванов').gender
  end
end
