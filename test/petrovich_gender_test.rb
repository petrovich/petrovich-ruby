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
end
