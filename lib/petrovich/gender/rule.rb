module Petrovich
  module Gender
    # A gender rule from the set of rules
    class Rule
      attr_reader :gender, :as, :suffix, :accuracy

      # TODO: check options (see Case::Rule)
      def initialize(opts)
        @gender = opts[:gender]
        @as = opts[:as]
        @suffix = /#{opts[:suffix]}$/i
        @accuracy = opts[:suffix].length
      end

      def match?(name)
        !!name.match(suffix)
      end
    end
  end
end
