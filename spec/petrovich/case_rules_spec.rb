# encoding: utf-8
require 'spec_helper'
if ENV['TEST_SURNAMES']
  describe "Склонение сложных русских" do
    context "мужских фамилий" do
      subject { Petrovich.new(:male) }

      context "в дательном падеже" do
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

    context "женских фамилий" do
      subject { Petrovich.new(:female) }

      context "в дательном падеже" do
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
  end
end
