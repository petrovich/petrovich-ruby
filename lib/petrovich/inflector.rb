module Petrovich
  class Inflector
    def initialize(name, gender, name_case)
      @name = name
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

    protected

    def inflect(name, rules)
      parts = name.split('-')
      parts.map! do |part|
        rule = rules.shift
        modifier = rule.get_modifier(@name_case)
        part.slice(0, part.size - modifier.offset) + modifier.suffix
      end

      parts.join('-')
    end
  end
end
