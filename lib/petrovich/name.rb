module Petrovich
  class Name
    def initialize(opts)
      @gender = opts[:gender]
      @name = OpenStruct.new(
        lastname: opts[:lastname],
        firstname: opts[:firstname],
        middlename: opts[:middlename]
      )
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

    def gender
      @gender || 'unknown'
    end

    def male?
      true
    end

    def female?
      true
    end

    def androgynous?
      true
    end

    Petrovich::CASES.each do |name_case|
      define_method name_case do
        Inflected.new(Petrovich.inflect(@name.dup, @gender, name_case))
      end

      define_method "#{name_case}?" do
        is?(name_case)
      end
    end

    private

    def is?(name_case)
      raise "Not implemented"
    end
  end
end
