module Petrovich
  # Keeps inflected @name
  class Inflected
    extend Forwardable

    def_delegator :@name, :lastname, :lastname
    def_delegator :@name, :firstname, :firstname
    def_delegator :@name, :middlename, :middlename

    def initialize(name)
      @name = name
    end

    def to_s
      [lastname, firstname, middlename].compact.join(' ')
    end
  end
end
