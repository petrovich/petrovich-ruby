# encoding: utf-8
require_relative 'test_helper'

describe Petrovich::Gender do
  it 'detects male gender by firstname' do
    assert_equal :male, Petrovich::Gender.detect(firstname: 'Александр')
  end

  it 'detects male gender by lastname' do
    assert_equal :male, Petrovich::Gender.detect(lastname: 'Склифасовский')
  end

  it 'detects female gender by firstname' do
    assert_equal :female, Petrovich::Gender.detect(firstname: 'Александра')
  end

  it 'detects female gender by lastname' do
    assert_equal :female, Petrovich::Gender.detect(lastname: 'Склифасовская')
  end

  it 'detects female gender by firstname and lastname' do
    assert_equal :female, Petrovich::Gender.detect(firstname: 'Александра', lastname: 'Склифасовская')
  end

  it 'detects androgynous gender by firstname' do
    assert_equal :androgynous, Petrovich::Gender.detect(firstname: 'Саша')
  end

  it 'detects androgynous gender by firstname and lastname' do
    assert_equal :androgynous, Petrovich::Gender.detect(firstname: 'Саша', lastname: 'Андрейчук')
  end

  it 'detects male gender by firstname and lastname' do
    assert_equal :male, Petrovich::Gender.detect(firstname: 'Саша', lastname: 'Иванов')
  end

  it 'detects male gender by firstname, lastname and middlename' do
    assert_equal :male, Petrovich::Gender.detect(firstname: 'Саша', lastname: 'Андрейчук', middlename: 'Олегович')
  end

  it 'detects male gender by firstname and middlename' do
    assert_equal :male, Petrovich::Gender.detect(firstname: 'Саша', middlename: 'Олегович')
  end

  it 'detects androgynous gender by lastname' do
    assert_equal :androgynous, Petrovich::Gender.detect(lastname: 'Осипчук')
  end

  it 'detects male gender by middlename' do
    assert_equal :male, Petrovich::Gender.detect(middlename: 'Олегович')
  end

  it 'detects female gender by middlename' do
    assert_equal :female, Petrovich::Gender.detect(middlename: 'Олеговна')
  end

  it 'fails with argument error test 1' do
    -> { Petrovich::Gender.detect(xxx: 'yyy') }.must_raise ArgumentError
  end

  it 'fails with argument error test 2' do
    -> { Petrovich::Gender.detect('wrong args') }.must_raise ArgumentError
  end

  it 'fails with argument error test 3' do
    -> { Petrovich::Gender.detect(firstname: nil, lastname: nil) }.must_raise ArgumentError
  end
end
