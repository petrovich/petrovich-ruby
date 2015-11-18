module Petrovich
  # Набор загруженных правил из YAML файла
  class RuleSet
    def initialize
      clear!
    end

    def add(rule)
      unless rule.is_a?(Rule)
        raise ArgumentError, "Expecting rule of type Petrovich::Rule".freeze
      end

      @rules << rule
    end

    # Для двойных имен, фамилий или отчеств нужно найти несколько правил,
    # чтобы использовать их для каждой части имени соответственно
    def find_all(name, gender, as)
      name.split('-').map { |part| find(part, gender, as) }
    end

    def clear!
      @rules = []
    end

    # Загрузка правил из YAML файла
    def load!
      return false if @rules.size > 0

      rules = YAML.load_file(
        File.expand_path('../../../rules/rules.yml', __FILE__)
      )

      [:lastname, :firstname, :middlename].each do |name_part|
        [:exceptions, :suffixes].each do |section|
          entries = rules[name_part.to_s][section.to_s]
          next if entries.nil?

          entries.each do |entry|
            load_entry(name_part, section, entry)
          end
        end
      end
    end

    protected

    # Найти правило для указанного имени
    def find(name, gender, as)
      @rules.find { |rule| rule.match?(name, gender, as) }
    end

    def load_entry(as, section, entry)
      modifiers = entry['mods'].map do |mod|
        suffix = mod.scan(/[^.-]+/).first
        offset = mod.count('-')
        Petrovich::Rule::Modifier.new(suffix, mod.count('-'))
      end

      tests = entry['test'].map do |suffix|
        Petrovich::Rule::Test.new(suffix)
      end

      add Petrovich::Rule.new(
        gender: entry['gender'],
        as: as,
        section: section,
        modifiers: modifiers,
        tests: tests,
        tags: entry['tags']
      )
    end
  end
end
