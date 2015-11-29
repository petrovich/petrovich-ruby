module Petrovich
  # Methods of determining gender by the name
  module Gender
    def self.detect(name)
      # Accept hash and convert it to ostruct object
      name     = Petrovich.normalize_name(name)
      rule_set = Petrovich.rule_set
      genders  = {}

      Petrovich.assert_name!(name)

      [:lastname, :firstname, :middlename].each do |name_part|
        next unless name.respond_to?(name_part) && name.send(name_part)

        rules = rule_set.find_all_gender_rules(name.send(name_part), name_part)

        rules.each do |rule|
          genders[name_part] = rule.nil? ? :androgynous : rule.gender
        end
      end

      # Return gender if middlename is specified and gender is determined.
      return genders[:middlename] if genders[:middlename] && genders[:middlename] != :androgynous

      if genders.values.uniq.size > 1
        if genders[:firstname] != :androgynous && genders[:lastname] == :androgynous
          return genders[:firstname]
        end

        if genders[:lastname] != :androgynous && genders[:firstname] == :androgynous
          return genders[:lastname]
        end
      end

      # Otherwise, it returns what recognized
      return genders.values.uniq.first if genders.values.uniq.size == 1
    end
  end
end
