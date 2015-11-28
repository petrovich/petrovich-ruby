module Petrovich
  # Модификатор правила
  class Case::Rule::Modifier
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
