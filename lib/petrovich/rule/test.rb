module Petrovich
  # Тест правила
  class Rule::Test
    attr_accessor :suffix

    def initialize(suffix)
      @suffix = suffix
    end

    def match?(value)
      raise "Not implemented"
    end

    def inspect
      suffix.inspect
    end
  end
end
