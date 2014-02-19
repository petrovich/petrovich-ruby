# encoding: utf-8

class Petrovich
  # Этот модуль разработан для возможности его подмешивания в класс Ruby.
  # Его можно подмешать в любой класс, например, в модель ActiveRecord.
  #
  # При помощи вызова метода +petrovich+ вы указываете, какие аттрибуты или методы класса
  # будут возвращать фамилию, имя и отчество.
  #
  # Опции:
  #
  # [:+firstname+]
  #   Указывает метод, возвращающий имя
  #
  # [:+middlename+]
  #   Указывает метод, возвращающий отчество
  #
  # [:+lastname+]
  #   Указывает метод, возвращающий фамилию
  #
  # [:+gender+]
  #   Указывает метод, возвращающий пол. Если пол не был указан, используется автоматическое определение
  #   пола на основе отчества. Если отчество также не было указано, пытаемся определить правильное склонение
  #   на основе файла правил.
  #
  # Пример использования
  #
  #   class User
  #     include Petrovich::Extension
  #
  #     petrovich :firstname  => :my_firstname,
  #               :middlename => :my_middlename,
  #               :lastname   => :my_lastname,
  #               :gender     => :my_gender
  #
  #     def my_firstname
  #       'Пётр'
  #     end
  #
  #     def my_middlename
  #       'Александрович'
  #     end
  #
  #     def my_lastname
  #       'Ларин'
  #     end
  #
  #     def my_gender
  #       :male # :male, :female или :androgynous
  #     end
  #
  #   end
  #
  # Вы получите следующие методы
  #
  #   user = User.new
  #   user.my_lastname_dative   # => Ларину
  #   user.my_firstname_dative  # => Петру
  #   user.my_middlename_dative # => Александровичу
  #
  # Вышеперечисленные методы доступны и внутри класса User.
  #
  module Extension
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def petrovich(options)
        class_eval do
          class << self
            attr_accessor :petrovich_configuration
          end
        end

        self.petrovich_configuration = {
          :lastname   => nil,
          :firstname  => nil,
          :middlename => nil,
          :gender     => nil
        }.merge(options)
      end
    end

    def petrovich_create_getter(method_name, attribute, gcase)
      options    = self.class.petrovich_configuration
      reflection = options.key(attribute.to_sym) or
        raise "No reflection for attribute '#{attribute}'!"

      self.class.send(:define_method, method_name) do
        # detect by gender attr if defined
        gender = options[:gender] && send(options[:gender])
        # detect by middlename attr if defined
        gender ||= begin
          middlename = options[:middlename] && send(options[:middlename])
          middlename && Petrovich.detect_gender(middlename)
        end

        rn = Petrovich.new gender
        rn.send reflection, send(attribute), gcase
      end
    end

    def method_missing(method_name, *args, &block)
      if match = method_name.to_s.match(petrovich_method_regex)
        attribute = match[1]
        gcase     = match[2]

        petrovich_create_getter(method_name, attribute, gcase)

        if respond_to_without_petrovich?(method_name)
          send method_name
        else
          super
        end
      else
        super
      end
    end

    alias :respond_to_without_petrovich? :respond_to?

    def respond_to?(method_name, include_private = false)
      if match = method_name.to_s.match(petrovich_method_regex)
        true
      else
        super
      end
    end

    def petrovich_method_regex
      %r{(.+)_(#{Petrovich::CASES.join('|')})$}
    end

    protected :petrovich_method_regex
  end
end
