# encoding: utf-8
require_relative 'test_helper'

describe Petrovich do
  it 'have inflect method' do
    firstname = Petrovich(
      firstname: 'Саша',
      gender: 'male'
    ).to(:dative).firstname

    assert_equal 'Саше', firstname
  end

  it 'inflects firstname 1' do
    firstname = Petrovich(
      firstname: 'Саша',
      gender: 'male'
    ).dative.firstname

    assert_equal 'Саше', firstname
  end

  it 'inflects lastname 1' do
    lastname = Petrovich(
      lastname: 'Кочубей',
      gender: 'male'
    ).dative.lastname

    assert_equal 'Кочубею', lastname
  end

  it 'inflects lastname 2' do
    lastname = Petrovich(
      lastname: 'Козлов',
      gender: 'male'
    ).dative.lastname

    assert_equal 'Козлову', lastname
  end

  it 'inflects lastname 3' do
    lastname = Petrovich(
      lastname: 'Салтыков-Щедрин',
      gender: 'male'
    ).dative.lastname

    assert_equal 'Салтыкову-Щедрину', lastname
  end

  it 'inflects lastname 4' do
    lastname = Petrovich(
      lastname: 'Дюма',
      gender: 'male'
    ).dative.lastname

    assert_equal 'Дюма', lastname
  end

  it 'inflects lastname 5' do
    lastname = Petrovich(
      lastname: 'Воробей',
      gender: 'male'
    ).dative.lastname

    assert_equal 'Воробью', lastname
  end

  it 'inflects lastname 6' do
    lastname = Petrovich(
      lastname: 'Воробей',
      gender: 'female'
    ).dative.lastname

    assert_equal 'Воробей', lastname
  end

  it 'inflects firstname 2' do
    firstname = Petrovich(
      firstname: 'Анна-Мария',
      gender: 'female'
    ).dative.firstname

    assert_equal 'Анне-Марии', firstname
  end

  it 'inflects middlename 1' do
    middlename = Petrovich(
      middlename: 'Борух-Бендитовна',
      gender: 'female'
    ).dative.middlename

    assert_equal 'Борух-Бендитовне', middlename
  end

  it 'inflects middlename 2' do
    middlename = Petrovich(
      middlename: 'Георгиевна-Авраамовна',
      gender: 'female'
    ).dative.middlename

    assert_equal 'Георгиевне-Авраамовне', middlename
  end

  it 'inflects lastname 2' do
    lastname = Petrovich(
      firstname: 'Иван',
      lastname: 'Плевако',
      gender: 'male'
    ).dative.lastname

    assert_equal 'Плевако', lastname
  end

  # Gender
  it 'is androgynous gender' do
    p = Petrovich(
      firstname: 'Саша',
      lastname: 'Андрейчук'
    )

    assert_equal true, p.androgynous?
  end

  it 'detects male gender' do
    p = Petrovich(
      firstname: 'Александр',
      lastname: 'Андрейчук'
    )

    assert_equal true, p.male?
  end

  it 'detects female gender' do
    p = Petrovich(
      firstname: 'Александра',
      lastname: 'Андрейчук'
    )

    assert_equal true, p.female?
  end

  ###

  it 'is androgynous gender returned by gender()' do
    p = Petrovich(
      firstname: 'Саша',
      lastname: 'Андрейчук'
    )

    assert_equal true, p.gender == :androgynous
  end

  it 'detects male gender returned by gender()' do
    p = Petrovich(
      firstname: 'Александр',
      lastname: 'Андрейчук'
    )

    assert_equal true, p.gender == :male
  end

  it 'detects female gender returned by gender()' do
    p = Petrovich(
      firstname: 'Александра',
      lastname: 'Андрейчук'
    )

    assert_equal true, p.gender == :female
  end

  it 'inflects lastname [ая]' do
    lastname = Petrovich(
      lastname: 'Слуцкая',
    ).dative.lastname

    assert_equal 'Слуцкой', lastname
  end

  it 'inflects male lastname' do
    lastname = Petrovich(
      lastname: 'Штеттер',
      gender: :male,
    ).dative.lastname

    assert_equal 'Штеттеру', lastname
  end

  # Future stuff
  # Petrovich.scan do |p|
  #   name = [p.lastname, p.firstname, p.middlename].join(' ')
  #
  #   "<a href='#'>#{name}</a>"
  # end
end
