module Petrovich
  module Case
    class Rule
      # A modifier for the test rule
      class Modifier
        attr_reader :suffix, :offset

        def initialize(suffix, offset = 0)
          @suffix = suffix.to_s
          @offset = offset
        end

        def inspect
          [suffix, offset].inspect
        end
      end
    end
  end
end
