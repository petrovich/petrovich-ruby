module Petrovich
  # Правило из списка правил
  class Rule
    GENDER_MALE = 0
    GENDER_FEMALE = 1
    GENDER_ANDROGYNOUS = 2

    TYPE_SUFFIX = 0
    TYPE_EXCEPTION = 1

    AS_LASTNAME = 0
    AS_FIRSTNAME = 1
    AS_MIDDLENAME = 2

    attr_reader :gender, :modifiers, :tests, :tags, :as, :type

    def initialize(opts)
      @gender = opts[:gender]
      @modifiers = opts[:modifiers]
      @tests = opts[:tests]
      @tags = []

      set_gender(opts[:gender])
      set_as(opts[:as])
      set_type(opts[:type])
    end

    def match?(name, as)
      true
    end

    def get_modifier(name_case)
      case name_case.to_sym
      when CASE_NOMINATIVE
        nil
      when CASE_GENITIVE
        @modifiers[0]
      when CASE_DATIVE
        @modifiers[1]
      when CASE_ACCUSATIVE
        @modifiers[2]
      when CASE_INSTRUMENTAL
        @modifiers[3]
      when CASE_PREPOSITIONAL
        @modifiers[4]
      else
        raise UnknownCaseError, "Unknown grammatic case: #{name_case}"
      end
    end

    private

    def set_gender(value)
      @gender = case value.to_s.downcase
      when 'male'.freeze, 'm'.freeze, GENDER_MALE
        GENDER_MALE
      when 'female'.freeze, 'f'.freeze, GENDER_FEMALE
        GENDER_FEMALE
      when 'androgynous'.freeze, 'a'.freeze, GENDER_ANDROGYNOUS
        GENDER_ANDROGYNOUS
      else
        raise ArgumentError, "Unknown gender #{value}"
      end
    end

    def set_as(value)
      @as = case value
      when :lastname,
        AS_LASTNAME
      when :firstname,
        AS_FIRSTNAME
      when :middlename,
        AS_MIDDLENAME
      else
        raise ArgumentError, "Unknown 'as' option #{value}"
      end
    end

    def set_type(value)
      @type = case value
      when :exceptions,
        TYPE_EXCEPTION
      when :suffixes
        TYPE_SUFFIX
      else
        raise ArgumentError, "Unknown 'type' option #{value}"
      end
    end
  end
end
