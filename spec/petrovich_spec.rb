# encoding: utf-8

require_relative 'spec_helper'

describe Petrovich do
  it 'have no gender' do
    Petrovich.new.gender.should == ''
  end

  it 'have male gender' do
    Petrovich.new(:male).gender.should == 'male'
  end

  it 'have female gender' do
    Petrovich.new(:female).gender.should == 'female'
  end

  it 'detects male gender' do
    Petrovich.detect_gender('Петрович').should == 'male'
  end
  
  it 'detects female gender' do
    Petrovich.detect_gender('Петровна').should == 'female'
  end

  it 'cant detects any gender (androgynous)' do
    Petrovich.detect_gender('Блабла').should == 'androgynous'
  end

  context 'name inflection methods' do
    it 'raises exception on unknown case for firstname' do
      expect { Petrovich.new.firstname('Иван', :unknown) }.to raise_error
    end

    it 'raises exception on unknown case for middlename' do
      expect { Petrovich.new.middlename('Петрович', :unknown) }.to raise_error
    end

    it 'raises exception on unknown case for lastname' do
      expect { Petrovich.new.lastname('Ковалёв', :unknown) }.to raise_error
    end

    it 'respects proper case for firstname' do
      expect { Petrovich.new.firstname('Иван', :instrumental) }.to_not raise_error
    end

    it 'respects proper case for middlename' do
      expect { Petrovich.new.middlename('Петрович', :instrumental) }.to_not raise_error
    end

    it 'respects proper case for lastname' do
      expect { Petrovich.new.lastname('Ковалёв', :instrumental) }.to_not raise_error
    end

    it 'have alias for middlename' do
      Petrovich.new.patronymic('Петрович', :instrumental).should == 'Петровичем'
    end
  end
end
