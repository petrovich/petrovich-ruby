module Petrovich
  module Case
    class Rule
      # A test for the case rule
      class Test
        attr_reader :suffix

        def initialize(suffix)
          @suffix = /#{suffix}$/i
        end

        def match?(name)
          !!name.match(suffix)
        end

        def inspect
          suffix.inspect
        end
      end
    end
  end
end
