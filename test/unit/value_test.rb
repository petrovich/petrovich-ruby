# encoding: utf-8
require_relative '../test_helper'

describe Petrovich::Value do
  it 'has nil defaults' do
    value = Petrovich::Value.new({})

    assert_nil value.lastname
    assert_nil value.firstname
    assert_nil value.middlename
  end

  it 'reads name parts from the hash' do
    value = Petrovich::Value.new(
      lastname: 'Иванов',
      firstname: 'Иван',
      middlename: 'Иванович'
    )

    assert_equal 'Иванов', value.lastname
    assert_equal 'Иван', value.firstname
    assert_equal 'Иванович', value.middlename
  end

  it 'allows name parts to be written' do
    value = Petrovich::Value.new({})

    value.lastname = 'Иванов'
    value.firstname = 'Иван'
    value.middlename = 'Иванович'

    assert_equal 'Иванов', value.lastname
    assert_equal 'Иван', value.firstname
    assert_equal 'Иванович', value.middlename
  end

  it 'returns nil for missing keys' do
    value = Petrovich::Value.new(lastname: 'Иванов')

    assert_equal 'Иванов', value.lastname
    assert_nil value.firstname
    assert_nil value.middlename
  end

  it 'ignores unknown keys' do
    value = Petrovich::Value.new(lastname: 'Иванов', nickname: 'Ваня')

    assert_equal 'Иванов', value.lastname
    refute value.respond_to?(:nickname)
  end

  it 'does not read string keys' do
    value = Petrovich::Value.new(
      'lastname' => 'Иванов',
      'firstname' => 'Иван',
      'middlename' => 'Иванович'
    )

    assert_nil value.lastname
    assert_nil value.firstname
    assert_nil value.middlename
  end
end
