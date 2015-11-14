module Petrovich
  # Модификатор правила
  class Rule::Modifier
    attr_reader :suffix, :offset

    def initialize(suffix, offset = 0) # --ей
      @suffix = suffix.to_s
      @offset = offset
    end

    def match?(value)
      raise "Not implemented"
    end

    def inspect
      [suffix, offset].inspect
    end
  end
end
