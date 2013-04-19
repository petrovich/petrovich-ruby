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
  # [:+order+]
  #   Задаёт порядок составляющих имени для их установки или вывода при использовании +:fullname+
  #
  # [:+fullname+]
  #   Задаёт или возвращает полное имя. Используется совместно с +:order+. 
  #
  #     petrovich :fullname => :my_fullname
  #               :order    => [:firstname, :middlename, :lastname]
  #
  #     def my_fullname
  #       'Аркадий Семёнович Дичко'
  #     end
  #
  #   Далее при вызове метода вы получите:
  #
  #     my_fullname_dative # => Аркадию Семёновичу Дичко
  #
  #
  # [:+delimeter+]
  #   Задаёт разделитель для +:fullname+. По-умолчанию равен +/\s+/+
  #
  # Пример использования
  # 
  #   class User
  #     include Petrovich::Extension
  #     attr_accessor :firstname, :middlename, :lastname
  #   
  #     petrovich :firstname  => :my_firstname,
  #               :middlename => :my_middlename,
  #               :lastname   => :my_lastname
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
          :fullname   => nil,
          :firstname  => nil,
          :middlename => nil,
          :lastname   => nil,
          :order      => [:lastname, :firstname, :middlename],
          :delimeter  => /\s+/
        }.merge(options)
      end
    end

    def petrovich_create_getter(method_name, attribute, gcase, name)
      options    = self.class.petrovich_configuration
      reflection = options.key(attribute.to_sym) or raise "No reflection for attribute '#{attribute}'!"

      self.class.send(:define_method, method_name) do
        rn = Petrovich.new
        rn.send(reflection, name, gcase)
      end
    end

    def method_missing(method_name, *args, &block)
      if match = method_name.to_s.match(%r{(.+)_(#{Petrovich::CASES.join('|')})$})
        attribute = match[1]
        name      = send(attribute)
        gcase     = match[2]

        petrovich_create_getter(method_name, attribute, gcase, name).call
      else
        super
      end
    end
  end
end