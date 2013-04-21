require 'active_support/core_ext'

class Petrovich
  # Загрузка правил происходит один раз
  RULES = YAML.load_file(File.dirname(__FILE__) + '/rules.yml')

  # Набор методов для нахождения и применения правил к имени, фамилии и отчеству.
  class Rules
    def initialize(gender = nil)
      @gender = gender
    end

    # Определяет методы +lastname_<i>case</i>+, +firstname_<i>case</i>+ и +middlename_<i>case</i>+
    # для получения имени, фамилии и отчества в нужном падеже.
    #
    # Использование:
    #
    #   # Дательный падеж
    #   lastname_dative('Комаров') # => Комарову
    #
    #   # Винительный падеж
    #   lastname_accusative('Комаров') # => Комарова
    #
    [:lastname, :firstname, :middlename].each do |m|
      define_method(m) { |name, gcase| find_and_apply(name, gcase, Petrovich::RULES[__method__.to_s]) }
    end

  protected

    def match?(name, rule, match_whole_word)
      return false if rule['gender'] == 'male' && female? || rule['gender'] == 'female' && !female?

      name = name.mb_chars.downcase
      rule['test'].each do |chars|
        test = match_whole_word ? name : name.slice([name.size - chars.size, 0].max .. -1)        
        return true if test == chars
      end

      false
    end

    def male?
      @gender == 'male'
    end

    def female?
      @gender == 'female'
    end

    # Применить правило
    def apply(name, gcase, rule)
      modificator_for(gcase, rule).each_char do |char|
        case char
          when '.'
          when '-'
            name = name.slice(0, name.size - 1)
          else
            name += char
        end
      end

      name
    end

    # Найти правило и применить к имени с учетом склонения
    def find_and_apply(name, gcase, rules)
      apply(name, gcase, find_for(name, rules))
    end

    # Найти подходящее правило в исключениях или суффиксах
    def find_for(name, rules)
      # Сначала пытаемся найти исключения
      if rules.has_key?('exceptions')
        p = find(name, rules['exceptions'], true)
        return p if p
      end

      # Не получилось, ищем в суффиксах. Если не получилось найти и в них,
      # возвращаем неизмененное имя.
      find(name, rules['suffixes'], false) || name
    end

    # Найти подходящее правило в конкретном списке правил
    def find(name, rules, match_whole_word)
      rules.find { |rule| match?(name, rule, match_whole_word) }
    end

    # Получить модификатор из указанного правиля для указанного склонения
    def modificator_for(gcase, rule)
      case gcase.to_sym
        when NOMINATIVE
          '.'
        when GENITIVE
          rule['mods'][0]
        when DATIVE
          rule['mods'][1]
        when ACCUSATIVE
          rule['mods'][2]
        when INSTRUMENTATIVE
          rule['mods'][3]
        when PREPOSITIONAL
          rule['mods'][4]
        else
          raise "Unknown grammatic case: #{gcase}"
      end
    end

  end
end