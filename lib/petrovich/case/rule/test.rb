module Petrovich
  module Case
    class Rule
      # A test for the case rule
      class Test
        attr_reader :suffix

        def initialize(suffix)
          @suffix = Unicode.downcase(suffix)
        end

        def match?(name)
          name = Unicode.downcase(name)
          suffix == name.slice([name.size - suffix.size, 0].max..-1)
        end

        def inspect
          suffix.inspect
        end
      end
    end
  end
end
