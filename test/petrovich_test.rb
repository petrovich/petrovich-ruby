# encoding: utf-8
require_relative 'test_helper'

describe Petrovich do
  it 'inflects firstname' do
    firstname = Petrovich(
      firstname: 'Саша',
      gender: 'male'
    ).dative.firstname

    assert_equal 'Саше', firstname
  end

  it 'inflects lastname' do
    lastname = Petrovich(
      lastname: 'Воробей',
      gender: 'male'
    ).dative.lastname

    assert_equal 'Воробью', lastname
  end
end

=begin
puts Petrovich(
  firstname: 'Саша',
  lastname: 'Воробей',
  gender: 'male'
).gender.inspect#.firstname.to_s # => Саше


Petrovich(
  firstname: 'Саша',
  lastname: 'Осипенко'
  gender: 'male'
).dative.to_s # => Осипенко Саше

Petrovich(
  firstname: 'Саша',
  lastname: 'Осипенко'
  gender: 'male'
).dative.firstname # => Саше

Petrovich(
  firstname: 'Саша',
  lastname: 'Осипенко'
  gender: 'male'
).dative? # => false

Petrovich(
  firstname: 'Иван',
  middlename: 'Иванович',
  lastname: 'Иванов'
).male? # => true

Petrovich(
  firstname: 'Иван',
  middlename: 'Иванович',
  lastname: 'Иванов'
).gender # => 'male'

Petrovich(
  firstname: 'Иван',
  middlename: 'Иванович',
  lastname: 'Иванов'
).dative.matched_rule # => Object

Petrovich(
  firstname: 'Иван',
  middlename: 'Иванович',
  lastname: 'Иванов'
).firstname # => Иван

Petrovich('Иван Иванович Иванов').dative.middlename # => Ивановичу

Petrovich.scan do |petrovich|
  name = [petrovich.lastname, petrovich.firstname, petrovich.middlename].join(' ')

  "<a href='#'>#{name}</a>"
end
=end

=begin
describe Petrovich do
  it 'have no gender' do
    assert_equal '', Petrovich.new.gender
  end

  it 'have male gender' do
    assert_equal 'male', Petrovich.new(:male).gender
  end

  it 'have female gender' do
    assert_equal 'female', Petrovich.new(:female).gender
  end

  it 'detects male gender' do
    assert_equal 'male', Petrovich.detect_gender('Петрович')
  end
  
  it 'detects female gender' do
    assert_equal 'female', Petrovich.detect_gender('Петровна')
  end

  it 'cant detects any gender (androgynous)' do
    assert_equal 'androgynous', Petrovich.detect_gender('Блабла')
  end

  describe 'name inflection methods' do
    it 'raises exception on unknown case for firstname' do
      assert_raises(Petrovich::UnknownCaseException) { Petrovich.new.firstname('Иван', :unknown) }
    end

    it 'raises exception on unknown case for middlename' do
      assert_raises(Petrovich::UnknownCaseException) { Petrovich.new.middlename('Петрович', :unknown) }
    end

    it 'raises exception on unknown case for lastname' do
      assert_raises(Petrovich::UnknownCaseException) { Petrovich.new.lastname('Ковалёв', :unknown) }
    end

    it 'respects proper case for firstname' do
      Petrovich.new.firstname('Иван', :instrumental)
    end

    it 'respects proper case for middlename' do
      Petrovich.new.middlename('Петрович', :instrumental)
    end

    it 'respects proper case for lastname' do
      Petrovich.new.lastname('Ковалёв', :instrumental)
    end

    it 'have alias for middlename' do
      assert_equal 'Петровичем', Petrovich.new.patronymic('Петрович', :instrumental)
    end
  end
end
=end
