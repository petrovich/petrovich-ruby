# encoding: utf-8
require 'spec_helper'

describe "Склонение сложных русских" do
  context "мужских фамилий" do
    subject { Petrovich.new(:male) }

    context "в родительном падеже" do
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
    end
  end

  context "женских фамилий" do
    subject { Petrovich.new(:female) }

    context "в родительном падеже" do
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
    end
  end
end