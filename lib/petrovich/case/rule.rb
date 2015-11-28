module Petrovich
  module Case
    # Правило из списка правил
    class Rule
      GENDER_MALE = 0
      GENDER_FEMALE = 1
      GENDER_ANDROGYNOUS = 2

      AS_LASTNAME = 0
      AS_FIRSTNAME = 1
      AS_MIDDLENAME = 2

      attr_reader :gender, :modifiers, :tests, :tags, :as, :an_exception

      def initialize(opts)
        @gender = process_gender(opts[:gender])
        @as = process_as(opts[:as])
        @an_exception = process_an_exception(opts[:section])
        @modifiers = opts[:modifiers]
        @tests = opts[:tests]
        @tags = []
      end

      def match?(name, match_gender, match_as)
        return false unless process_as(match_as) == as

        match_gender = process_gender(match_gender)

        return false if gender == GENDER_MALE && match_gender == GENDER_FEMALE
        return false if gender == GENDER_FEMALE && match_gender != GENDER_FEMALE

        tests.detect { |test| test.match?(name) }
      end

      # Является ли данное правило исключением?
      def an_exception?
        an_exception == true
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

      def process_gender(value)
        case value.to_s.downcase
        when 'male', 'm', GENDER_MALE
          GENDER_MALE
        when 'female', 'f', GENDER_FEMALE
          GENDER_FEMALE
        when 'androgynous', 'a', GENDER_ANDROGYNOUS
          GENDER_ANDROGYNOUS
        else
          GENDER_MALE
        end
      end

      def process_as(value)
        case value
        when :lastname
          AS_LASTNAME
        when :firstname
          AS_FIRSTNAME
        when :middlename
          AS_MIDDLENAME
        else
          raise ArgumentError, "Unknown 'as' option #{value}"
        end
      end

      def process_an_exception(value)
        value == :exceptions
      end
    end
  end
end
