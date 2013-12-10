# encoding: utf-8

class Petrovich
  # Загрузка правил происходит один раз
  RULES = YAML.load_file(File.expand_path('../../../rules/rules.yml', __FILE__))

  class UnknownCaseException < Exception;;end
  class UnknownRuleException < Exception;;end
  class CantApplyRuleException < Exception;;end

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
    [:lastname, :firstname, :middlename].each do |method_name|
      define_method(method_name) do |name, gcase, scase|
        inflect(name, gcase, scase, Petrovich::RULES[method_name.to_s])
      end
    end

  protected
    # Известно несколько типов признаков, которые влияют на процесс поиска.
    #
    # Признак +first_word+ указывает, что данное слово является первым словом
    # в составном слове. Например, в двойной русской фамилии Иванов-Сидоров.
    #
    def match?(name, gcase, scase, rule, match_whole_word, tags)
      return false unless tags_allow? tags, rule['tags']
      return false if rule['gender'] == 'male' && female? ||
                      rule['gender'] == 'female' && !female?

      name = UnicodeUtils.downcase(name)
      rule['test'].each do |chars|
        begin
          chars = apply(chars, rule, scase, gcase) if scase != NOMINATIVE
        rescue CantApplyRuleException
          next
        end

        test = match_whole_word ? name : name.slice([name.size - chars.size, 0].max .. -1)
        return chars if test == chars
      end

      false
    end

    def male?
      @gender == 'male'
    end

    def female?
      @gender == 'female'
    end

    def inflect(name, gcase, scase, rules)
      i = 0

      parts = name.split('-')

      parts.map! do |part|
        first_word = (i += 1) == 1 && parts.size > 1
        find_and_apply(part, gcase, scase, rules, first_word: first_word)
      end

      parts.join('-')
    end

    # Применить правило
    def apply(name, rule, gcase, scase)
      mod = modificator_from(scase, rule) + modificator_for(gcase, rule)
      skip = 0
      mod.each_char do |char|
        case char
          when '.'
          when '-'
            raise CantApplyRuleException if name.empty?
            name = name.slice(0, name.size - 1)
          else
            name += char
        end
      end

      name
    end

    # Найти правило и применить к имени с учетом склонения
    def find_and_apply(name, gcase, scase, rules, features = {})
      rule = find_for(name, gcase, scase, rules, features)
      apply(name, rule, gcase, scase)
    rescue UnknownRuleException, CantApplyRuleException
      # Если не найдено правило для имени, или случилась ошибка применения
      # правила, возвращаем неизмененное имя.
      name
    end

    # Найти подходящее правило в исключениях или суффиксах
    def find_for(name, gcase, scase, rules, features = {})
      tags = extract_tags(features)

      # Сначала пытаемся найти исключения
      if rules.has_key?('exceptions')
        p = find(name, gcase, scase, rules['exceptions'], true, tags)
        return p if p
      end

      # Не получилось, ищем в суффиксах. Если не получилось найти и в них,
      # возвращаем неизмененное имя.
      find(name, gcase, scase, rules['suffixes'], false, tags) ||
      raise( UnknownRuleException, "Cannot find rule for #{name}" )
    end

    # Найти подходящее правило в конкретном списке правил
    def find(name, gcase, scase, rules, match_whole_word, tags)
      first =
      rules.map do| rule |
        score = match?(name, gcase, scase, rule, match_whole_word, tags)
        score && [ score, rule ] || nil
      end.compact.sort do| x, y |
        c = y[ 0 ].size <=> x[ 0 ].size
        c != 0 && c || x[ 1 ][ 'gender' ] == @gender && -1 ||
                       y[ 1 ][ 'gender' ] == @gender &&  1 || 0
      end.first

      first && first[ 1 ]
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
        when INSTRUMENTAL
          rule['mods'][3]
        when PREPOSITIONAL
          rule['mods'][4]
        else
          raise UnknownCaseException, "Unknown grammatic case: #{gcase}"
      end
    end

    # Получить модификатор из указанного правила для преобразования
    # из указанного склонения
    def modificator_from(scase, rule)
      return '.' if scase.to_sym == NOMINATIVE

      # TODO т.к. именительный падеж не может быть восстановлен
      # в некоторых случаях верно, используется первый попавшийся вариант
      # видимо нужно менять формат таблицы, или развязывать варианты,
      # находящиеся в поле test
      base = rule['test'][0].unpack('U*')
      mod = modificator_for(scase, rule).unpack('U*')
      mod.map do | char |
        case char
        when 46 # '.'
          46
        when 45 # '-'
          base.pop
        else
          45
        end
      end.reverse.pack('U*')
    end

    # Преобразование +{a: true, b: false, c: true}+ в +%w(a c)+.
    def extract_tags(features = {})
      features.keys.select { |k| features[k] == true }.map(&:to_s)
    end

    # Правило не подходит только в том случае, если оно содержит больше
    # тегов, чем требуется для данного слова.
    #
    def tags_allow?(tags, rule_tags)
      rule_tags ||= []
      (rule_tags - tags).empty?
    end
  end
end
