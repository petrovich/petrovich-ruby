# encoding: utf-8
require_relative '../test_helper'

describe Petrovich::Name do
  def build_name(opts)
    Petrovich::Name.new(opts)
  end

  it 'knows an explicitly given gender' do
    assert_equal true, build_name(firstname: 'Иван', gender: :male).known_gender?
    assert_equal true, build_name(firstname: 'Иван', gender: 'female').known_gender?
    assert_equal true, build_name(firstname: 'Иван', gender: :androgynous).known_gender?
  end

  it 'does not know a missing or unknown gender' do
    assert_equal false, build_name(firstname: 'Иван').known_gender?
    assert_equal false, build_name(firstname: 'Иван', gender: :unknown).known_gender?
  end

  it 'returns an explicitly given gender' do
    assert_equal :male, build_name(firstname: 'Иван', gender: :male).gender
    assert_equal :female, build_name(firstname: 'Иван', gender: 'female').gender
  end

  it 'detects a gender when it is missing or invalid' do
    assert_equal :male, build_name(firstname: 'Александр').gender
    assert_equal :male, build_name(firstname: 'Александр', gender: :unknown).gender
  end

  it 'answers gender predicates using an explicit gender' do
    male = build_name(firstname: 'Саша', gender: :male)

    assert_equal true, male.male?
    assert_equal false, male.female?
    assert_equal false, male.androgynous?

    female = build_name(firstname: 'Саша', gender: :female)

    assert_equal false, female.male?
    assert_equal true, female.female?
    assert_equal false, female.androgynous?

    androgynous = build_name(firstname: 'Саша', gender: :androgynous)

    assert_equal false, androgynous.male?
    assert_equal false, androgynous.female?
    assert_equal true, androgynous.androgynous?
  end

  it 'answers gender predicates using a detected gender' do
    male = build_name(firstname: 'Александр')

    assert_equal true, male.male?
    assert_equal false, male.female?
    assert_equal false, male.androgynous?
  end

  it 'returns false for all gender predicates when the gender conflicts' do
    name = build_name(firstname: 'Александр', lastname: 'Склифасовская')

    assert_nil name.gender
    assert_equal false, name.male?
    assert_equal false, name.female?
    assert_equal false, name.androgynous?
  end

  it 'provides a method for every known case' do
    name = build_name(
      lastname: 'Иванов',
      firstname: 'Иван',
      middlename: 'Иванович',
      gender: :male
    )

    Petrovich::CASES.each do |name_case|
      inflected = name.to(name_case)

      assert_instance_of Petrovich::Inflected, inflected
      assert_equal inflected.to_s, name.send(name_case).to_s
    end
  end

  it 'does not change a name in the nominative case' do
    name = build_name(
      lastname: 'Иванов',
      firstname: 'Иван',
      middlename: 'Иванович',
      gender: :male
    )

    assert_equal 'Иванов Иван Иванович', name.to(:nominative).to_s
  end

  it 'rejects unknown and string cases' do
    name = build_name(lastname: 'Иванов', gender: :male)

    assert_raises(ArgumentError) { name.to(:bogus) }
    assert_raises(ArgumentError) { name.to('dative') }
  end

  it 'does not mutate the original name' do
    name = build_name(lastname: 'Иванов', firstname: 'Иван', gender: :male)

    first_call = name.dative.to_s
    second_call = name.dative.to_s

    assert_equal 'Иванову Ивану', first_call
    assert_equal first_call, second_call
    assert_equal 'Иванов Иван', name.to_s
  end

  it 'renders a full name' do
    name = build_name(
      lastname: 'Иванов',
      firstname: 'Иван',
      middlename: 'Иванович'
    )

    assert_equal 'Иванов Иван Иванович', name.to_s
  end

  it 'renders partial names without redundant spaces' do
    assert_equal 'Иванов', build_name(lastname: 'Иванов').to_s
    assert_equal 'Иван', build_name(firstname: 'Иван').to_s
    assert_equal 'Иванович', build_name(middlename: 'Иванович').to_s
  end

  it 'renders an empty string for an empty name' do
    assert_equal '', build_name(lastname: nil, firstname: nil, middlename: nil).to_s
  end

  it 'delegates name parts to the original value' do
    name = build_name(
      lastname: 'Иванов',
      firstname: 'Иван',
      middlename: 'Иванович'
    )

    assert_equal 'Иванов', name.lastname
    assert_equal 'Иван', name.firstname
    assert_equal 'Иванович', name.middlename
  end

  it 'inflects partial names' do
    assert_equal 'Иванова', build_name(lastname: 'Иванов', gender: :male).genitive.lastname
    assert_equal 'Ивана', build_name(firstname: 'Иван', gender: :male).genitive.firstname
    assert_equal 'Ивановича', build_name(middlename: 'Иванович', gender: :male).genitive.middlename
  end

  it 'uses an explicit gender for inflection' do
    assert_equal 'Воробей', build_name(lastname: 'Воробей', gender: :female).dative.lastname
    assert_equal 'Воробью', build_name(lastname: 'Воробей', gender: :male).dative.lastname
  end
end
