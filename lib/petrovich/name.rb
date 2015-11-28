module Petrovich
  class Name
    extend Forwardable

    def_delegator :@name, :lastname, :lastname
    def_delegator :@name, :firstname, :firstname
    def_delegator :@name, :middlename, :middlename

    def initialize(opts)
      @rule_set = Petrovich.rule_set
      @gender = opts[:gender]
      @name = OpenStruct.new(
        lastname: opts[:lastname],
        firstname: opts[:firstname],
        middlename: opts[:middlename]
      )
    end

    def gender
      if @gender && [:male, :female, :androgynous].include?(@gender.to_sym)
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

    def to_s
      [lastname, firstname, middlename].join(' ')
    end

    Petrovich::CASES.each do |name_case|
      define_method name_case do
        Inflected.new(inflect(@name.dup, @gender, name_case))
      end

      define_method "#{name_case}?" do
        is?(@name, name_case)
      end
    end

    private

    def inflect(name, gender, name_case)
      inflector = Inflector.new(name, gender, name_case)

      if !name.lastname.nil? && (rules = @rule_set.find_all_case_rules(name.lastname, gender, :lastname))
        name.lastname = inflector.inflect_lastname(rules)
      end

      if !name.firstname.nil? && (rules = @rule_set.find_all_case_rules(name.firstname, gender, :firstname))
        name.firstname = inflector.inflect_firstname(rules)
      end

      if !name.middlename.nil? && (rules = @rule_set.find_all_case_rules(name.middlename, gender, :middlename))
        name.middlename = inflector.inflect_middlename(rules)
      end

      name
    end

    def is?(name, name_case)
      raise "Not implemented #{name_case}? method"
    end
  end
end
