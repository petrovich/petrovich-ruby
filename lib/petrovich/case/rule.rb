module Petrovich
  module Case
    # Правило из списка правил
    class Rule
      attr_reader :gender, :modifiers, :tests, :tags, :as, :an_exception

      def initialize(opts)
        @gender       = opts[:gender].to_sym.downcase
        @as           = opts[:as]
        @an_exception = opts[:section] == :exceptions
        @modifiers    = opts[:modifiers]
        @tests        = opts[:tests]
        @tags         = []

        assert_name_part!(@as)
      end

      def match?(name, match_gender, match_as)
        assert_name_part!(match_as)

        return false unless match_as == as

        match_gender = match_gender.to_sym.downcase

        return false if gender == :male && match_gender == :female
        return false if gender == :female && match_gender != :female

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
          modifiers[0]
        when CASE_DATIVE
          modifiers[1]
        when CASE_ACCUSATIVE
          modifiers[2]
        when CASE_INSTRUMENTAL
          modifiers[3]
        when CASE_PREPOSITIONAL
          modifiers[4]
        else
          raise UnknownCaseError, "Unknown grammatic case: #{name_case}".freeze
        end
      end

      private

      def assert_name_part!(name_part)
        unless [:lastname, :firstname, :middlename].include?(name_part)
          raise ArgumentError, "Unknown 'as' option #{name_part}".freeze
        end
      end
    end
  end
end
