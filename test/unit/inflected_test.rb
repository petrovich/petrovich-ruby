# encoding: utf-8
require_relative '../test_helper'

describe Petrovich::Inflected do
  def inflected(opts)
    Petrovich::Inflected.new(Petrovich::Value.new(opts))
  end

  it 'joins the full name' do
    assert_equal 'Иванов Иван Иванович', inflected(
      lastname: 'Иванов',
      firstname: 'Иван',
      middlename: 'Иванович'
    ).to_s
  end

  it 'joins a name without a middle name' do
    assert_equal 'Иванов Иван', inflected(
      lastname: 'Иванов',
      firstname: 'Иван'
    ).to_s
  end

  it 'renders a last name alone' do
    assert_equal 'Иванов', inflected(lastname: 'Иванов').to_s
  end

  it 'renders an empty string for an empty name' do
    assert_equal '', inflected({}).to_s
  end

  it 'delegates name parts to the original value' do
    value = Petrovich::Value.new(
      lastname: 'Иванов',
      firstname: 'Иван',
      middlename: 'Иванович'
    )
    inflected_name = Petrovich::Inflected.new(value)

    assert_equal 'Иванов', inflected_name.lastname
    assert_equal 'Иван', inflected_name.firstname
    assert_equal 'Иванович', inflected_name.middlename
  end
end
