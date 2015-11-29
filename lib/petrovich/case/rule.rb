module Petrovich
  module Case
    # A case rule from the set of rules
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

      # Is this exceptional rule?
      def an_exception?
        an_exception == true
      end

      def get_modifier(name_case)
        case name_case.to_sym
        when :nominative
          nil
        when :genitive
          modifiers[0]
        when :dative
          modifiers[1]
        when :accusative
          modifiers[2]
        when :instrumental
          modifiers[3]
        when :prepositional
          modifiers[4]
        else
          fail UnknownCaseError, "Unknown grammatic case: #{name_case}".freeze
        end
      end

      private

      def assert_name_part!(name_part)
        return if [:lastname, :firstname, :middlename].include?(name_part)
        fail ArgumentError, "Unknown 'as' option #{name_part}".freeze
      end
    end
  end
end
