module Petrovich
  class Inflector
    def initialize(name, gender, name_case)
      @name = Petrovich.normalize_name(name)
      Petrovich.assert_name!(@name)

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

    # Inflects every word of the name with the next rule and keeps the
    # separators between words as they are. The words are the same as in
    # RuleSet#find_all_case_rules: splitting with a captured separator puts
    # words at even indices and separators at odd ones.
    #
    # A single compound rule (see RuleSet#find_all_case_rules) is applied to
    # the whole name instead.
    def inflect(name, rules)
      return name if rules.size == 0
      return apply(name, rules.shift) if rules.size == 1 && rules.first && rules.first.compound?

      tokens = name.split(Petrovich::WORD_SEPARATOR_CAPTURE)
      tokens.each_with_index.map do |token, index|
        index.odd? ? token : apply(token, rules.shift)
      end.join
    end

    def apply(word, rule)
      modifier = rule && rule.get_modifier(@name_case)
      return word unless modifier

      word.slice(0, word.size - modifier.offset) + modifier.suffix
    end
  end
end
