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

  # to_s
  it 'joins name parts without redundant spaces' do
    assert_equal 'Иванов', Petrovich(lastname: 'Иванов').to_s
    assert_equal 'Иван', Petrovich(firstname: 'Иван').to_s
    assert_equal 'Иванович', Petrovich(middlename: 'Иванович').to_s
    assert_equal 'Иванов Иван Иванович', Petrovich(
      lastname: 'Иванов',
      firstname: 'Иван',
      middlename: 'Иванович'
    ).to_s
  end

  it 'returns an empty string for an empty name' do
    assert_equal '', Petrovich(
      lastname: nil,
      firstname: nil,
      middlename: nil
    ).to_s
  end

  it 'joins inflected name parts without redundant spaces' do
    assert_equal 'Иванову', Petrovich(
      lastname: 'Иванов',
      gender: :male
    ).dative.to_s
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

  it 'respects explicit gender in gender predicates' do
    p = Petrovich(
      firstname: 'Саша',
      lastname: 'Андрейчук',
      gender: :male
    )

    assert_equal true, p.male?
    assert_equal false, p.female?
    assert_equal false, p.androgynous?
  end

  it 'respects explicit gender given as string in gender predicates' do
    p = Petrovich(
      firstname: 'Саша',
      lastname: 'Андрейчук',
      gender: 'female'
    )

    assert_equal true, p.female?
    assert_equal false, p.male?
  end

  it 'prefers explicit gender over detected one in gender predicates' do
    p = Petrovich(
      firstname: 'Александр',
      gender: :female
    )

    assert_equal true, p.female?
    assert_equal false, p.male?
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

  it 'inflects male lastname' do
    lastname = Petrovich(
      lastname: 'Коломиец',
    ).genitive.lastname

    assert_equal 'Коломийца', lastname
  end

  it 'inflects male lastname' do
    lastname = Petrovich(
      lastname: 'Быхун',
    ).instrumental.lastname

    assert_equal 'Быхуном', lastname
  end

  # Canonical declension tables

  it 'inflects a male full name in every case' do
    expected = {
      nominative: 'Иванов Иван Иванович',
      genitive: 'Иванова Ивана Ивановича',
      dative: 'Иванову Ивану Ивановичу',
      accusative: 'Иванова Ивана Ивановича',
      instrumental: 'Ивановым Иваном Ивановичем',
      prepositional: 'Иванове Иване Ивановиче'
    }

    expected.each do |name_case, value|
      assert_equal value, Petrovich(
        lastname: 'Иванов',
        firstname: 'Иван',
        middlename: 'Иванович',
        gender: :male
      ).to(name_case).to_s
    end
  end

  it 'inflects a female full name in every case' do
    expected = {
      nominative: 'Иванова Анна Ивановна',
      genitive: 'Ивановой Анны Ивановны',
      dative: 'Ивановой Анне Ивановне',
      accusative: 'Иванову Анну Ивановну',
      instrumental: 'Ивановой Анной Ивановной',
      prepositional: 'Ивановой Анне Ивановне'
    }

    expected.each do |name_case, value|
      assert_equal value, Petrovich(
        lastname: 'Иванова',
        firstname: 'Анна',
        middlename: 'Ивановна',
        gender: :female
      ).to(name_case).to_s
    end
  end

  it 'inflects a male hyphenated last name in every case' do
    expected = {
      nominative: 'Салтыков-Щедрин',
      genitive: 'Салтыкова-Щедрина',
      dative: 'Салтыкову-Щедрину',
      accusative: 'Салтыкова-Щедрина',
      instrumental: 'Салтыковым-Щедриным',
      prepositional: 'Салтыкове-Щедрине'
    }

    expected.each do |name_case, value|
      assert_equal value, Petrovich(
        lastname: 'Салтыков-Щедрин',
        gender: :male
      ).to(name_case).lastname
    end
  end

  it 'inflects a female hyphenated last name in every case' do
    expected = {
      nominative: 'Салтыкова-Щедрина',
      genitive: 'Салтыковой-Щедриной',
      dative: 'Салтыковой-Щедриной',
      accusative: 'Салтыкову-Щедрину',
      instrumental: 'Салтыковой-Щедриной',
      prepositional: 'Салтыковой-Щедриной'
    }

    expected.each do |name_case, value|
      assert_equal value, Petrovich(
        lastname: 'Салтыкова-Щедрина',
        gender: :female
      ).to(name_case).lastname
    end
  end

  it 'inflects full hyphenated names' do
    assert_equal 'Салтыкову-Щедрину Михаилу Евграфовичу', Petrovich(
      lastname: 'Салтыков-Щедрин',
      firstname: 'Михаил',
      middlename: 'Евграфович',
      gender: :male
    ).dative.to_s

    assert_equal 'Салтыковым-Щедриным Михаилом Евграфовичем', Petrovich(
      lastname: 'Салтыков-Щедрин',
      firstname: 'Михаил',
      middlename: 'Евграфович',
      gender: :male
    ).instrumental.to_s

    assert_equal 'Салтыковой-Щедриной Анне Ивановне', Petrovich(
      lastname: 'Салтыкова-Щедрина',
      firstname: 'Анна',
      middlename: 'Ивановна',
      gender: :female
    ).dative.to_s

    assert_equal 'Салтыковой-Щедриной Анной Ивановной', Petrovich(
      lastname: 'Салтыкова-Щедрина',
      firstname: 'Анна',
      middlename: 'Ивановна',
      gender: :female
    ).instrumental.to_s
  end

  it 'allows chaining after to()' do
    name = Petrovich(
      lastname: 'Салтыков-Щедрин',
      firstname: 'Михаил',
      middlename: 'Евграфович',
      gender: :male
    )

    assert_equal 'Евграфовичем', name.to(:instrumental).middlename
  end

  it 'inflects partial names' do
    assert_equal 'Иванова', Petrovich(lastname: 'Иванов', gender: :male).genitive.lastname
    assert_equal 'Ивана', Petrovich(firstname: 'Иван', gender: :male).genitive.firstname
    assert_equal 'Ивановича', Petrovich(middlename: 'Иванович', gender: :male).genitive.middlename
  end

  it 'returns the same result on repeated calls' do
    name = Petrovich(lastname: 'Иванов', firstname: 'Иван', gender: :male)

    assert_equal name.dative.to_s, name.dative.to_s
    assert_equal 'Иванов Иван', name.to_s
  end

  it 'respects an explicit gender in inflection' do
    assert_equal 'Воробью', Petrovich(lastname: 'Воробей', gender: :male).dative.lastname
    assert_equal 'Воробей', Petrovich(lastname: 'Воробей', gender: :female).dative.lastname
  end

  it 'inflects a name with conflicting genders' do
    skip 'known bug: conflicting genders fall back to androgynous rules'

    assert_equal 'Склифасовской Александру', Petrovich(
      firstname: 'Александр',
      lastname: 'Склифасовская'
    ).dative.to_s
  end

  # Future stuff
  # Petrovich.scan do |p|
  #   name = [p.lastname, p.firstname, p.middlename].join(' ')
  #
  #   "<a href='#'>#{name}</a>"
  # end
end
