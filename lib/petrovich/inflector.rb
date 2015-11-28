module Petrovich
  class Inflector
    def initialize(name, gender, name_case)
      Petrovich.assert_name!(name)

      @name = Petrovich.normalize_name(name)
      @gender = gender
      @name_case = name_case
    end

    def inflect_lastname(rules)
      inflect(@name.lastname, rules)
    end

    def inflect_firstname(rules)
      inflect(@name.firstname, rules)
    end

    def inflect_middlename(rules)
      inflect(@name.middlename, rules)
    end

    private

    def inflect(name, rules)
      return name if rules.size == 0

      parts = name.split('-')
      parts.map! do |part|
        rule = rules.shift

        if rule && (modifier = rule.get_modifier(@name_case))
          part.slice(0, part.size - modifier.offset) + modifier.suffix
        else
          part
        end
      end

      parts.join('-')
    end
  end
end
