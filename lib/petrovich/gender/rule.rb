module Petrovich
  module Gender
    # A gender rule from the set of rules
    class Rule
      attr_reader :gender, :as, :suffix

      # TODO: check options (see Case::Rule)
      def initialize(opts)
        @gender = opts[:gender]
        @as = opts[:as]
        @suffix = /#{opts[:suffix]}$/i
      end

      def match?(name, match_as)
        return false unless match_as == as

        !!name.match(suffix)
      end
    end
  end
end
