module Petrovich
  # Keeps inflected @name
  class Inflected
    def initialize(name)
      @name = name
    end

    def lastname
      @name.lastname
    end

    def firstname
      @name.firstname
    end

    def middlename
      @name.middlename
    end

    def to_s
      [lastname, firstname, middlename].compact.join(" ")
    end
  end
end
