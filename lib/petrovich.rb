# encoding: utf-8
require 'yaml'
require 'unicode_utils'
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
    # Если пол не был определён, метод возвращает значение +androgynous+
    #
    #   detect_gender('блаблабла') # => androgynous
    #
    def detect_gender(midname)
      case UnicodeUtils.downcase(midname[-2, 2])
        when 'ич'
          'male'
        when 'на'
          'female'
        else
          'androgynous'
      end
    end
  end
end
