module Petrovich
  class Name
    extend Forwardable

    def_delegator :@name, :lastname, :lastname
    def_delegator :@name, :firstname, :firstname
    def_delegator :@name, :middlename, :middlename

    def initialize(opts)
      @rule_set = Petrovich.rule_set
      @gender = opts[:gender]
      @name = Petrovich.normalize_name(
        lastname: opts[:lastname],
        firstname: opts[:firstname],
        middlename: opts[:middlename]
      )
    end

    def gender
      if !@gender.nil? && [:male, :female, :androgynous].include?(@gender.to_sym)
        @gender.to_sym
      else
        Gender.detect(@name)
      end
    end

    def male?
      Gender.detect(@name) == :male
    end

    def female?
      Gender.detect(@name) == :female
    end

    def androgynous?
      Gender.detect(@name) == :androgynous
    end

    def to(name_case)
      Petrovich.assert_case!(name_case)
      Inflected.new(inflect(@name.dup, gender, name_case))
    end

    def to_s
      [lastname, firstname, middlename].join(' ')
    end

    Petrovich::CASES.each do |name_case|
      define_method name_case do
        to(name_case)
      end
    end

    private

    def inflect(name, gender, name_case)
      inflector = Inflector.new(name, gender, name_case)
      find = proc { |x| @rule_set.find_all_case_rules(name.send(x), gender, x) }

      if !name.lastname.nil? && (rules = find.call(:lastname))
        name.lastname = inflector.inflect_lastname(rules)
      end

      if !name.firstname.nil? && (rules = find.call(:firstname))
        name.firstname = inflector.inflect_firstname(rules)
      end

      if !name.middlename.nil? && (rules = find.call(:middlename))
        name.middlename = inflector.inflect_middlename(rules)
      end

      name
    end
  end
end
