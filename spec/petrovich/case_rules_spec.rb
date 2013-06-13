# encoding: utf-8

require_relative '../spec_helper'

describe 'Склонение сложных русских' do
  context 'мужских' do
    subject { Petrovich.new(:male) }

    context 'фамилий' do
      context 'в дательном падеже' do
        it { subject.lastname('Бильжо', :dative).should == 'Бильжо' }
        it { subject.lastname('Ничипорук', :dative).should == 'Ничипоруку' }
        it { subject.lastname('Щусь', :dative).should == 'Щусю' }
        it { subject.lastname('Фидря', :dative).should == 'Фидре' }
        it { subject.lastname('Белоконь', :dative).should == 'Белоконю' }
        it { subject.lastname('Добробаба', :dative).should == 'Добробабе' }
        it { subject.lastname('Исайченко', :dative).should == 'Исайченко' }
        it { subject.lastname('Бондаришин', :dative).should == 'Бондаришину' }
        it { subject.lastname('Дубинка', :dative).should == 'Дубинке' }
        it { subject.lastname('Сирота', :dative).should == 'Сироте' }
        it { subject.lastname('Воевода', :dative).should == 'Воеводе' }
        it { subject.lastname('Волож', :dative).should == 'Воложу' }
        it { subject.lastname('Кравец', :dative).should == 'Кравцу' }
        it { subject.lastname('Самотечний', :dative).should == 'Самотечнему' }
        it { subject.lastname('Цой', :dative).should == 'Цою' }
        it { subject.lastname('Шопен', :dative).should == 'Шопену' }
        it { subject.lastname('Сосковец', :dative).should == 'Сосковцу' }
      end
    end
  end

  context 'женских' do
    subject { Petrovich.new(:female) }

    context 'фамилий' do
      context 'в дательном падеже' do
        it { subject.lastname('Бильжо', :dative).should == 'Бильжо' }
        it { subject.lastname('Ничипорук', :dative).should == 'Ничипорук' }
        it { subject.lastname('Щусь', :dative).should == 'Щусь' }
        it { subject.lastname('Фидря', :dative).should == 'Фидре' }
        it { subject.lastname('Белоконь', :dative).should == 'Белоконь' }
        it { subject.lastname('Добробаба', :dative).should == 'Добробабе' }
        it { subject.lastname('Исайченко', :dative).should == 'Исайченко' }
        it { subject.lastname('Бондаришин', :dative).should == 'Бондаришин' }
        it { subject.lastname('Дубинка', :dative).should == 'Дубинке' }
        it { subject.lastname('Сирота', :dative).should == 'Сироте' }
        it { subject.lastname('Воевода', :dative).should == 'Воеводе' }
        it { subject.lastname('Гулыга', :dative).should == 'Гулыге' }
        it { subject.lastname('Дейнека', :dative).should == 'Дейнеке' }
        it { subject.lastname('Джанджагава', :dative).should == 'Джанджагава' }
        it { subject.lastname('Забейворота', :dative).should == 'Забейворота' }
        it { subject.lastname('Окуджава', :dative).should == 'Окуджаве' }
      end
    end

    context 'имён' do
      context 'Маша' do
        it { subject.firstname('Маша', :genitive).should == 'Маши' }
        it { subject.firstname('Маша', :dative).should == 'Маше' }
        it { subject.firstname('Маша', :accusative).should == 'Машу' }
        it { subject.firstname('Маша', :instrumental).should == 'Машей' }
        it { subject.firstname('Маша', :prepositional).should == 'Маше' }
      end
    end
  end
end
