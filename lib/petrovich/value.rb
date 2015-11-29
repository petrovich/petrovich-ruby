module Petrovich
  # Value-object for name
  class Value
    attr_accessor :firstname, :lastname, :middlename

    def initialize(name)
      @firstname = name[:firstname]
      @lastname = name[:lastname]
      @middlename = name[:middlename]
    end
  end
end
