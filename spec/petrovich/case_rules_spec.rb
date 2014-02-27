# encoding: utf-8

require 'spec_helper'

describe 'Склонение сложных русских' do
  describe 'мужских' do
    subject { Petrovich.new(:male) }

    describe 'фамилий' do
      describe 'в дательном падеже' do
        it { assert_equal 'Бильжо', subject.lastname('Бильжо', :dative) }
        it { assert_equal 'Ничипоруку', subject.lastname('Ничипорук', :dative) }
        it { assert_equal 'Щусю', subject.lastname('Щусь', :dative) }
        it { assert_equal 'Фидре', subject.lastname('Фидря', :dative) }
        it { assert_equal 'Белоконю', subject.lastname('Белоконь', :dative) }
        it { assert_equal 'Добробабе', subject.lastname('Добробаба', :dative) }
        it { assert_equal 'Исайченко', subject.lastname('Исайченко', :dative) }
        it { assert_equal 'Бондаришину', subject.lastname('Бондаришин', :dative) }
        it { assert_equal 'Дубинке', subject.lastname('Дубинка', :dative) }
        it { assert_equal 'Сироте', subject.lastname('Сирота', :dative) }
        it { assert_equal 'Воеводе', subject.lastname('Воевода', :dative) }
        it { assert_equal 'Воложу', subject.lastname('Волож', :dative) }
        it { assert_equal 'Кравцу', subject.lastname('Кравец', :dative) }
        it { assert_equal 'Самотечнему', subject.lastname('Самотечний', :dative) }
        it { assert_equal 'Цою', subject.lastname('Цой', :dative) }
        it { assert_equal 'Шопену', subject.lastname('Шопен', :dative) }
        it { assert_equal 'Сосковцу', subject.lastname('Сосковец', :dative) }
      end
    end
  end

  describe 'женских' do
    subject { Petrovich.new(:female) }

    describe 'фамилий' do
      describe 'в дательном падеже' do
        it { assert_equal 'Бильжо', subject.lastname('Бильжо', :dative) }
        it { assert_equal 'Ничипорук', subject.lastname('Ничипорук', :dative) }
        it { assert_equal 'Щусь', subject.lastname('Щусь', :dative) }
        it { assert_equal 'Фидре', subject.lastname('Фидря', :dative) }
        it { assert_equal 'Белоконь', subject.lastname('Белоконь', :dative) }
        it { assert_equal 'Добробабе', subject.lastname('Добробаба', :dative) }
        it { assert_equal 'Исайченко', subject.lastname('Исайченко', :dative) }
        it { assert_equal 'Бондаришин', subject.lastname('Бондаришин', :dative) }
        it { assert_equal 'Дубинке', subject.lastname('Дубинка', :dative) }
        it { assert_equal 'Сироте', subject.lastname('Сирота', :dative) }
        it { assert_equal 'Воеводе', subject.lastname('Воевода', :dative) }
        it { assert_equal 'Гулыге', subject.lastname('Гулыга', :dative) }
        it { assert_equal 'Дейнеке', subject.lastname('Дейнека', :dative) }
        it { assert_equal 'Джанджагава', subject.lastname('Джанджагава', :dative) }
        it { assert_equal 'Забейворота', subject.lastname('Забейворота', :dative) }
        it { assert_equal 'Окуджаве', subject.lastname('Окуджава', :dative) }
      end
    end

    describe 'имён' do
      describe 'Маша' do
        it { assert_equal 'Маши', subject.firstname('Маша', :genitive) }
        it { assert_equal 'Маше', subject.firstname('Маша', :dative) }
        it { assert_equal 'Машу', subject.firstname('Маша', :accusative) }
        it { assert_equal 'Машей', subject.firstname('Маша', :instrumental) }
        it { assert_equal 'Маше', subject.firstname('Маша', :prepositional) }
      end
    end
  end
end
