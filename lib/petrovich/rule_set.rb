module Petrovich
  # Набор загруженных правил из YAML файла
  class RuleSet
    def initialize
      clear!
    end

    def add_case_rule(rule)
      unless rule.is_a?(Case::Rule)
        raise ArgumentError, "Expecting rule of type Petrovich::Case::Rule".freeze
      end

      @case_rules << rule
    end

    def add_gender_rule(rule)
      unless rule.is_a?(Gender::Rule)
        raise ArgumentError, "Expecting rule of type Petrovich::Gender::Rule".freeze
      end

      @gender_rules << rule
    end

    # Для двойных имен, фамилий или отчеств нужно найти несколько правил,
    # чтобы использовать их для каждой части имени соответственно
    def find_all_case_rules(name, gender, as)
      name.split('-').map { |part| find_case_rule(part, gender, as) }
    end

    def find_all_gender_rules(name, as)
      name.split('-').map { |part| find_gender_rule(part, as) }
    end

    def clear!
      @case_rules = []
      @gender_rules = []
    end

    # Загрузка правил из YAML файла
    def load!
      return false if @case_rules.size > 0

      rules = YAML.load_file(
        File.expand_path('../../../rules.yml', __FILE__)
      )

      load_case_rules!(rules)
      load_gender_rules!(rules)
    end

    protected

    # Load rules for names
    def load_case_rules!(rules)
      [:lastname, :firstname, :middlename].each do |name_part|
        [:exceptions, :suffixes].each do |section|
          entries = rules[name_part.to_s][section.to_s]
          next if entries.nil?

          entries.each do |entry|
            load_case_entry(name_part, section, entry)
          end
        end
      end
    end

    # Load rules for genders
    def load_gender_rules!(rules)
      [:lastname, :firstname, :middlename].each do |name_part|
        # First, add androgynous rules. Order is matters.
        [:androgynous, :male, :female].each do |section|
          entries = rules['gender'][name_part.to_s][section.to_s]
          next if entries.nil?

          entries.each do |entry|
            load_gender_entry(name_part, section, entry)
          end
        end
      end
    end

    # Найти правило для указанного имени
    def find_case_rule(name, gender, as)
      @case_rules.find { |rule| rule.match?(name, gender, as) }
    end

    def find_gender_rule(name, as)
      @gender_rules.find { |rule| rule.match?(name, as) }
    end

    def load_case_entry(as, section, entry)
      modifiers = entry['mods'].map do |mod|
        suffix = mod.scan(/[^.-]+/).first
        offset = mod.count('-')
        Petrovich::Case::Rule::Modifier.new(suffix, mod.count('-'))
      end

      tests = entry['test'].map do |suffix|
        Petrovich::Case::Rule::Test.new(suffix)
      end

      add_case_rule Petrovich::Case::Rule.new(
        gender: entry['gender'],
        as: as,
        section: section,
        modifiers: modifiers,
        tests: tests,
        tags: entry['tags']
      )
    end

    def load_gender_entry(as, section, entry)
      add_gender_rule Gender::Rule.new(
        as: as,
        gender: section,
        suffix: entry
      )
    end
  end
end
