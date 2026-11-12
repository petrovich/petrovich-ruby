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

    # A double first name declines only its last part
    # (docs/compound-surnames-plan.md, decision R-1).
    assert_equal 'Анна-Марии', firstname
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

  # B-01: canonical values, docs/testing-plan.md section 5.2 (one row = one test).
  # Columns: ID, name, gender (nil = not given), case, expected inflected name.
  b01_canonical_cases = [
    ['C-01', { lastname: 'Иванов-Бонч' }, nil, :genitive, 'Иванова-Бонча'],
    ['C-02', { lastname: 'Иванов-Бонч' }, nil, :dative, 'Иванову-Бончу'],
    ['C-03', { lastname: 'Иванова-Бонч' }, :female, :genitive, 'Ивановой-Бонч'],
    ['C-04', { lastname: 'Бонч' }, nil, :genitive, 'Бонча'],
    ['C-05', { lastname: 'Бонч' }, :male, :genitive, 'Бонча'],
    ['C-06', { lastname: 'Бонч' }, :female, :genitive, 'Бонч'],
    ['C-07', { lastname: 'Бонч-Бруевич' }, nil, :genitive, 'Бонч-Бруевича'],
    ['C-08', { lastname: 'Абдул-Хамид' }, nil, :genitive, 'Абдул-Хамида'],
    ['C-09', { lastname: 'Ван-Гог' }, nil, :genitive, 'Ван-Гога'],
    ['C-10', { lastname: 'Тер-Петросян' }, nil, :genitive, 'Тер-Петросяна'],
    ['C-11', { lastname: 'Ван дер Ваальс' }, :male, :genitive, 'Ван дер Ваальса'],
    ['C-12', { lastname: 'О\'Коннор' }, :male, :genitive, "О'Коннора"],
    ['C-13', { lastname: 'Воробей' }, :male, :genitive, 'Воробья'],
    ['C-14', { lastname: 'Черных' }, :male, :genitive, 'Черных'],
    ['C-15', { lastname: 'Коваленко' }, :male, :genitive, 'Коваленко'],
    ['C-16', { lastname: 'Дюма' }, :male, :genitive, 'Дюма'],
    ['C-17', { lastname: 'Борух' }, :male, :genitive, 'Боруха'],
    ['C-18', { lastname: 'Борух' }, :female, :genitive, 'Борух'],
    ['C-19', { middlename: 'Борух' }, nil, :genitive, 'Борух'],
    ['C-20', { middlename: 'Али кызы' }, :female, :genitive, 'Али кызы'],
    ['C-21', { firstname: 'Любовь' }, :female, :genitive, 'Любови'],
    ['C-22', { firstname: 'Никита' }, :male, :genitive, 'Никиты'],
    ['C-23', { lastname: 'Бонч' }, nil, :instrumental, 'Бончем'],
    ['C-24', { lastname: 'Бонч' }, :androgynous, :genitive, 'Бонча'],
    ['C-25', { lastname: 'Абдул' }, nil, :genitive, 'Абдула'],
    ['C-26', { lastname: 'Ван' }, nil, :genitive, 'Вана'],
    ['C-27', { lastname: 'Тер' }, nil, :genitive, 'Тера'],
    ['C-28', { lastname: 'Фон' }, nil, :genitive, 'Фона'],
    ['C-29', { lastname: 'Бонч-Бонч' }, nil, :genitive, 'Бонч-Бонча'],
    ['C-30', { lastname: 'Фон-Бонч' }, nil, :genitive, 'Фон-Бонча'],
    ['C-31', { lastname: 'Абдулов-Ван' }, nil, :genitive, 'Абдулова-Вана'],
    ['C-32', { lastname: 'Дюма-Бонч' }, nil, :genitive, 'Дюма-Бонча'],
    ['C-33', { lastname: 'Иванов-Петров-Бонч' }, nil, :genitive, 'Иванова-Петрова-Бонча'],
    ['C-34', { lastname: 'Иванов-Бонч', firstname: 'Пётр' }, nil, :genitive, 'Иванова-Бонча Петра'],
    ['C-35', { lastname: 'Иванов-Бонч-Бруевич' }, nil, :genitive, 'Иванова-Бонч-Бруевича'],
    ['C-36', { lastname: 'Петров-Ван-Бетховен' }, nil, :genitive, 'Петрова-Ван-Бетховена'],
    ['C-37', { lastname: 'Бонч-Бруевич-Иванов' }, nil, :genitive, 'Бонч-Бруевича-Иванова'],
    ['C-38', { lastname: 'Бонч-Бруевич' }, :female, :genitive, 'Бонч-Бруевич'],
    ['C-39', { lastname: 'Бонч-Бруевич', firstname: 'Мария' }, nil, :genitive, 'Бонч-Бруевич Марии'],
    ['C-40', { lastname: 'Бонч-Бруевич' }, nil, :instrumental, 'Бонч-Бруевичем'],
    ['C-41', { lastname: 'Бонч-Бруевич' }, nil, :prepositional, 'Бонч-Бруевиче'],
    ['C-42', { lastname: 'бонч-бруевич' }, nil, :genitive, 'бонч-бруевича'],
    ['C-43', { lastname: 'Бончев' }, nil, :genitive, 'Бончева'],
    ['C-44', { lastname: 'Бончев-Бруевич' }, nil, :genitive, 'Бончева-Бруевича'],
    ['C-45', { lastname: 'Иванов-Бонч' }, :male, :genitive, 'Иванова-Бонча'],
    ['C-46', { lastname: 'Иванов-Бонч' }, :female, :genitive, 'Иванов-Бонч'],
    ['C-47', { lastname: 'Дюссар' }, :male, :genitive, 'Дюссара'],
    ['C-48', { lastname: 'Абдул' }, :female, :genitive, 'Абдул'],
    ['C-49', { lastname: 'Книппер-Чехова' }, :female, :genitive, 'Книппер-Чеховой'],
    ['C-50', { lastname: 'Корвин-Круковский' }, :male, :genitive, 'Корвин-Круковского'],
    ['C-51', { lastname: 'Мелик-Пашаева' }, :female, :instrumental, 'Мелик-Пашаевой'],
    ['C-52', { firstname: 'Баба-Яга' }, :female, :genitive, 'Бабы-Яги'],
    ['C-53', { middlename: 'Борух-Ааронович' }, :male, :genitive, 'Борух-Аароновича'],
    ['C-54', { lastname: 'Бонч-Бруевич', firstname: 'Ван', middlename: 'Борух' }, :male, :genitive, 'Бонч-Бруевича Вана Борух'],
    ['C-55', { lastname: 'Смирнов-Шевченко' }, :male, :genitive, 'Смирнова-Шевченко'],
    ['C-56', { lastname: 'Петров-Черных' }, :male, :genitive, 'Петрова-Черных'],
    ['C-57', { lastname: 'Иванова-де-Лонг' }, :female, :genitive, 'Ивановой-де-Лонг'],
    ['C-58', { lastname: 'Соколова-Фон-Берг' }, :female, :genitive, 'Соколовой-Фон-Берг'],
    ['C-59', { lastname: 'Мамин-Сибиряк' }, :male, :genitive, 'Мамина-Сибиряка'],
    ['C-60', { lastname: 'Римский-Корсаков' }, :male, :genitive, 'Римского-Корсакова'],
    ['C-61', { lastname: 'Соловьев-Седой' }, :male, :genitive, 'Соловьева-Седого'],
    ['C-62', { lastname: 'Салтыкова-Щедрина' }, :female, :genitive, 'Салтыковой-Щедриной'],
    ['C-63', { lastname: 'Римская-Корсакова' }, :female, :genitive, 'Римской-Корсаковой'],
    ['C-64', { lastname: 'Иванов-Петров-Сидоров' }, :male, :genitive, 'Иванова-Петрова-Сидорова'],
    ['C-65', { lastname: 'Голенищев-Кутузов-Смоленский' }, :male, :genitive, 'Голенищева-Кутузова-Смоленского'],
    ['C-66', { middlename: 'Али-оглы' }, :male, :genitive, 'Али-оглы'],
    ['C-67', { lastname: 'фон Бисмарк' }, :male, :genitive, 'фон Бисмарка'],
    ['C-68', { lastname: 'де Лафайет' }, :male, :genitive, 'де Лафайета'],
    ['C-69', { lastname: 'Шмидт-Иванова' }, :female, :genitive, 'Шмидт-Ивановой'],
    ['C-70', { lastname: 'Шмидт-Иванов' }, :male, :genitive, 'Шмидта-Иванова'],
    ['C-71', { lastname: 'Жан-Поль' }, :male, :genitive, 'Жана-Поля']
  ].freeze

  b01_canonical_cases.each do |id, name, gender, name_case, expected|
    it "#{id} inflects #{name.values.join(' ')} (#{gender || 'no gender'}, #{name_case})" do
      options = gender ? name.merge(gender: gender) : name

      assert_equal expected, Petrovich(options).to(name_case).to_s
    end
  end

  # B-02/B-05: canonical values, docs/compound-surnames-plan.md section 5.2
  # (one row = one test). Columns: ID, name, gender (nil = not given), case,
  # expected inflected name.
  compound_canonical_cases = [
    ['M-01', { lastname: 'ван Гог' }, :male, :genitive, 'ван Гога'],
    ['M-02', { lastname: 'фон дер Ляйен' }, :female, :genitive, 'фон дер Ляйен'],
    ['M-03', { lastname: 'де Голль' }, :male, :genitive, 'де Голля'],
    ['M-04', { lastname: 'Ле-Корбюзье' }, :male, :genitive, 'Ле-Корбюзье'],
    ['M-05', { lastname: 'Гарсиа Маркес' }, :male, :genitive, 'Гарсиа Маркеса'],
    ['M-06', { lastname: 'Мебарак Риполль' }, :female, :genitive, 'Мебарак Риполль'],
    ['M-07', { lastname: 'Крус Санчес' }, :female, :genitive, 'Крус Санчес'],
    ['M-08', { lastname: 'Гарсиа Маркес', firstname: 'Габриэль' }, nil, :genitive, 'Гарсиа Маркеса Габриэля'],
    ['M-09', { lastname: 'Мебарак Риполль', firstname: 'Шакира' }, nil, :genitive, 'Мебарак Риполль Шакиры'],
    ['M-10', { lastname: 'де Голль', firstname: 'Шарль' }, nil, :genitive, 'де Голля Шарля'],
    ['M-11', { lastname: 'ван Гог', firstname: 'Винсент' }, nil, :genitive, 'ван Гога Винсента'],
    ['M-12', { lastname: 'Ван дер Ваальс' }, :male, :genitive, 'Ван дер Ваальса'],
    ['M-13', { lastname: 'фон дер Берг' }, :male, :genitive, 'фон дер Берга'],
    ['M-14', { lastname: 'Родригес де Сильва Веласкес' }, :male, :genitive, 'Родригес де Сильва Веласкеса'],
    ['M-15', { lastname: 'Родригес де Сильва Веласкес' }, :male, :dative, 'Родригес де Сильва Веласкесу'],
    ['M-16', { lastname: 'Родригес де Сильва Веласкес', firstname: 'Диего' }, nil, :genitive, 'Родригес де Сильва Веласкеса Диего'],
    ['M-17', { firstname: 'Жан Поль' }, :male, :genitive, 'Жан Поля'],
    ['M-18', { lastname: 'Сент-Экзюпери' }, :male, :genitive, 'Сент-Экзюпери'],
    ['M-19', { lastname: 'Да-Винчи' }, :male, :genitive, 'Да-Винчи'],
    ['M-20', { lastname: 'Душ-Сантуш' }, :male, :genitive, 'Душ-Сантуша'],
    ['M-21', { lastname: 'Крус Санчес', firstname: 'Пенелопа' }, nil, :genitive, 'Крус Санчес Пенелопы'],
    ['M-22', { lastname: 'фон дер Ляйен', firstname: 'Урсула' }, nil, :genitive, 'фон дер Ляйен Урсулы'],
    ['M-23', { lastname: 'Лопес Обрадор' }, :male, :genitive, 'Лопеса Обрадора'],
    ['M-24', { lastname: 'Родригес Сапатеро' }, :male, :genitive, 'Родригеса Сапатеро'],
    ['M-25', { lastname: 'Роналду душ Сантуш Авейру' }, :male, :genitive, 'Роналду душ Сантуша Авейру'],
    ['M-26', { lastname: 'Роналду душ Сантуш Авейру', firstname: 'Криштиану' }, nil, :genitive, 'Роналду душ Сантуша Авейру Криштиану'],
    ['M-27', { lastname: 'де Сент-Экзюпери' }, :male, :genitive, 'де Сент-Экзюпери'],
    ['M-28', { lastname: 'де Сент-Экзюпери', firstname: 'Антуан' }, nil, :genitive, 'де Сент-Экзюпери Антуана'],
    ['M-29', { lastname: 'Иванов - Петров' }, nil, :genitive, 'Иванова - Петрова'],
    ['M-30', { lastname: 'Бонч-' }, nil, :genitive, 'Бонча-'],
    ['M-31', { lastname: 'Фон-Дер-Ла-Тор' }, nil, :genitive, 'Фон-Дер-Ла-Тора'],
    ['M-32', { lastname: 'Фон-Дер-Ла-Тор' }, :female, :genitive, 'Фон-Дер-Ла-Тор'],
    ['M-33', { lastname: 'Заяц' }, :male, :genitive, 'Зайца'],
    ['M-34', { lastname: 'Фон-дер-Берг' }, :male, :genitive, 'Фон-дер-Берга'],
    ['M-35', { lastname: 'Де-ла-Рош' }, :male, :genitive, 'Де-ла-Роша'],
    ['M-36', { lastname: 'Ван-дер-Ваальс' }, :male, :genitive, 'Ван-дер-Ваальса'],
    ['M-37', { lastname: 'Грум-Гржимайло' }, :male, :genitive, 'Грум-Гржимайло'],
    ['M-38', { lastname: 'Кара-Мурза' }, :male, :genitive, 'Кара-Мурзы'],
    ['M-39', { firstname: 'Абдул-Азиз' }, :male, :genitive, 'Абдул-Азиза'],
    ['M-40', { lastname: 'Дюма-отец' }, :male, :genitive, 'Дюма-отца'],
    ['M-41', { firstname: 'Полад-заде' }, :male, :genitive, 'Полад-заде'],
    ['M-42', { firstname: 'Жан-Поль' }, :male, :genitive, 'Жан-Поля'],
    ['M-43', { firstname: 'Жан-Жак' }, :male, :genitive, 'Жан-Жака'],
    ['M-44', { firstname: 'Пьер-Огюст' }, :male, :genitive, 'Пьер-Огюста'],
    ['M-45', { firstname: 'Франц-Иосиф' }, :male, :genitive, 'Франц-Иосифа']
  ].freeze

  compound_canonical_cases.each do |id, name, gender, name_case, expected|
    it "#{id} inflects #{name.values.join(' ')} (#{gender || 'no gender'}, #{name_case})" do
      options = gender ? name.merge(gender: gender) : name

      assert_equal expected, Petrovich(options).to(name_case).to_s
    end
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
