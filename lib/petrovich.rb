# encoding: utf-8
require 'yaml'
require 'petrovich/rules'
require 'petrovich/extension'

# Склонение падежей русских имён фамилий и отчеств. Вы задаёте начальное имя в именительном падеже,
# а получаете в нужном вам.
# 
# Использование
# 
#   # Склонение в дательном падеже
#   rn = Petrovich.new
#   puts rn.firstname('Иван', :dative)       # => Ивану
#   puts rn.middlename('Сергеевич', :dative) # => Сергеевичу
#   puts rn.lastname('Воронов', :dative)     # => Воронову
#
#
# Если известен пол, то его можно передать в конструктор. Это повышает точность склонений
#
#   rn = Petrovich.new('male')
#
# Если пол не известен, его можно определить по отчеству, при помощи метода +detect_gender+
#
#   gender = Petrovich.detect_gender('Сергеевич')
#   rn = Petrovich.new(gender)
#
# Возможные падежи
#
# * +:nominative+ - именительный
# * +:genitive+ - родительный
# * +:dative+ - дательный
# * +:accusative+ - винительный
# * +:instrumentative+ - творительный
# * +:prepositional+ - предложный
#
class Petrovich
  CASES = [:nominative, :genitive, :dative, :accusative, :instrumentative, :prepositional]

  NOMINATIVE      = :nominative      # именительный
  GENITIVE        = :genitive        # родительный
  DATIVE          = :dative          # дательный
  ACCUSATIVE      = :accusative      # винительный
  INSTRUMENTATIVE = :instrumentative # творительный
  PREPOSITIONAL   = :prepositional   # предложный

  def initialize(gender = nil)
    @gender = gender.to_s
  end

  def lastname(name, gcase)
    Rules.new(@gender).lastname(name, gcase)
  end

  def firstname(name, gcase)
    Rules.new(@gender).firstname(name, gcase)
  end

  def middlename(name, gcase)
    Rules.new(@gender).middlename(name, gcase)
  end

  alias :patronymic :middlename

  def gender
    @gender
  end

  class << self
    # Определение пола по отчеству
    #
    #   detect_gender('Алексеевич') # => male
    #
    # Если пол не был определён, метод возвращает значение +both+
    #
    #   detect_gender('блаблабла') # => both
    #
    def detect_gender(midname)
      case midname[-2, 2].mb_chars.downcase
        when 'ич'
          'male'
        when 'на'
          'female'
        else
          'both'
      end
    end
  end
end

###################################################################################################
=begin
class User
  include Petrovich::Extension

  petrovich :firstname  => :my_firstname,
               :middlename => :my_middlename,
               :lastname   => :my_lastname

  def my_firstname
    'Пётр'
  end

  def my_middlename
    'Александрович'
  end

  def my_lastname
    'Ларин'
  end
end


gender = Petrovich.detect_gender('Анатольевич')
rn = Petrovich.new(gender)
puts rn.firstname('Андрей', :dative)
puts rn.middlename('Анатольевич', :dative)
puts rn.lastname('Козлов', :dative)

puts '-' * 10

gender = Petrovich.detect_gender('Сергеевич')
rn = Petrovich.new(gender)
puts rn.firstname('Иван', :dative)
puts rn.middlename('Сергеевич', :dative)
puts rn.lastname('Степанович', :dative)


user = User.new
puts user.my_lastname_dative
puts user.my_firstname_dative
puts user.my_middlename_dative
=end