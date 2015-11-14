module Petrovich
  class Inflector
    def initialize(name, gender, name_case)
      @name = name
      @gender = gender
      @name_case = name_case
    end

    def inflect_lastname(rule)
      modifier = rule.get_modifier(@name_case)
      @name.lastname.slice(0, @name.lastname.size - modifier.offset) + modifier.suffix
    end

    def inflect_firstname(rule)
      modifier = rule.get_modifier(@name_case)
      @name.firstname.slice(0, @name.firstname.size - modifier.offset) + modifier.suffix
    end

    def inflect_middlename(rule)
      modifier = rule.get_modifier(@name_case)
      @name.middlename.slice(0, @name.middlename.size - modifier.offset) + modifier.suffix
    end
  end
end
