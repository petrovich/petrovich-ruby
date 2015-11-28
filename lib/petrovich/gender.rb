module Petrovich
  # Методы определения пола по ФИО
  module Gender
    def self.detect(name)
      # Accept hash and convert it to ostruct object
      name     = Petrovich.normalize_name(name)
      rule_set = Petrovich.rule_set
      genders  = {}

      Petrovich.assert_name!(name)

      [:lastname, :firstname, :middlename].each do |name_part|
        if name.respond_to?(name_part)
          rules = rule_set.find_all_gender_rules(name.send(name_part), name_part)

          rules.each do |rule|
            genders[name_part] = if rule.nil?
              :androgynous
            else
              rule.gender
            end
          end
        end
      end

      # Если указано отчество и определен пол - сразу возвращаем пол
      return genders[:middlename] if genders[:middlename] && genders[:middlename] != :androgynous

      if genders.values.uniq.size > 1
        return genders[:firstname] if genders[:firstname] != :androgynous && genders[:lastname] == :androgynous
        return genders[:lastname] if genders[:lastname] != :androgynous && genders[:firstname] == :androgynous
      end

      # В противном случает возвращаем то, что определили
      return genders.values.uniq.first if genders.values.uniq.size == 1
    end
  end
end
