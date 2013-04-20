![Petrovich Logo](https://raw.github.com/rocsci/petrovich/master/petrovich.png)

Склонение падежей русских имён, фамилий и отчеств. Вы задаёте начальное имя в именительном падеже, а получаете в нужном вам.

[![Build Status](https://secure.travis-ci.org/rocsci/petrovich.png)](http://travis-ci.org/rocsci/petrovich)

## Установка

Добавьте в Gemfile:

    gem 'petrovich'

Установите гем:

    $ bundle

Или, установите отдельно:

    $ gem install petrovich

## Использование

Вы задаёте начальные значения (фамилию, имя и отчество) в именительном падеже. Самое простое использование выглядит так:

```ruby
# Указание пола снижает количество отказов
p = Petrovich.new(:male)
p.lastname('Иванов', :dative)    # => Иванову
p.firstname('Пётр', :dative)     # => Петру
p.lastname('Сергеевич', :dative) # => Сергеевичу
```

Конструктор класса `Petrovich` принимает в качестве единственного аргумента пол. Пол может иметь значения `:male`, `:female` или `:both`. Последнее означает, что имя не склоняется по родам (обычно, это не нужно).

### Продвинутое использование

Вы можете подмешать модуль `Petrovich::Extension` в любой класс. Это особенно полезно при использовании `ActiveRecord`, и подобных ORM.

```ruby
class User < ActiveRecord::Base
  include Petrovich::Extension

  petrovich :firstname  => :my_firstname,
            :middlename => :my_middlename,
            :lastname   => :my_lastname

  def my_firstname
    'Пётр'
  end

  def my_middlename
    'Петрович'
  end

  def my_lastname
    'Петренко'
  end
end
```

Или, подмешиваем в обычный класс:

```ruby
class Person
  include Petrovich::Extension

  petrovich :firstname  => :name,
            :middlename => :patronymic,
            :lastname   => :surname

  def name
    'Иван'
  end

  def patronymic
    'Олегович'
  end

  def surname
    'Сафронов'
  end
end
```

В примерах выше, вы указываете при помощи метода `petrovich` соответствие фамилии, имени и отчества соответствующим методам или аттрибутам класса. После этого, вы легко можете склонять имена, используя следующий синтаксис вызовов:

```ruby
user = User.new
user.my_firstname # => Пётр
user.my_firstname_dative # => Петру
```

и для второго примера:

```ruby
person = User.new
person.name # => Иван
person.name_dative # => Ивану
```

Вы просто добавляете `_падеж` в конец имени оригинального метода и получаете нужное значение. Вот список суффиксов, которые вы можете добавить к имени оригинального метода, чтобы получить имя в нужном падаже:

 * nominative      - именительный
 * genitive        - родительный
 * dative          - дательный
 * accusative      - винительный
 * instrumentative - творительный
 * prepositional   - предложный

## Разработчики

 * [Андрей Козлов](https://github.com/tanraya) - идея, реализация
 * [Дмитрий Усталов](https://github.com/eveel) - неоценимая помощь

## Содействие

Если вы нашли баги, как программной части, так и в словаре, вы всегда можете форкнуть репозиторий и внести необходимые правки. Ваша помощь не останется незамеченной. Если вы заметили ошибки при склонении падежей имён, фамилий или отчеств, можете написать об этом в issues. Проблема будет сразу же исследована и решена.

Как всегда, чтобы помочь, вам нужно:

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
