# encoding: utf-8

require 'csv'

desc 'Evaluate the inflector on surnames'
task :evaluate => :petrovich do
  filename = File.expand_path('../../../spec/data/surnames.tsv', __FILE__)
  errors_filename = ENV['errors'] || 'errors.tsv'

  correct, total = Hash.new(0), Hash.new(0)

  puts 'I will evaluate the inflector on "%s" ' \
       'and store errors to "%s".' % [filename, errors_filename]

  CSV.open(errors_filename, 'w', col_sep: "\t") do |errors|
    errors << %w(lemma expected actual grammemes params)

    CSV.open(filename, col_sep: "\t", headers: true).each do |row|
      word, lemma = row['word'], row['lemma']
      grammemes = row['grammemes'] ? row['grammemes'].split(',') : []

      next if grammemes.include? 'мн'

      gender = grammemes.include?('мр') ? :male : :female
      gcase = if grammemes.include? 'им' or grammemes.include? '0'
        :nominative
      elsif grammemes.include? 'рд'
        :genitive
      elsif grammemes.include? 'дт'
        :dative
      elsif grammemes.include? 'вн'
        :accusative
      elsif grammemes.include? 'тв'
        # actually, it's called the instrumetal case
        :instrumentative
      elsif grammemes.include? 'пр'
        :prepositional
      end

      inflector = Petrovich.new(gender)
      inflection = begin
        UnicodeUtils.upcase(inflector.lastname(lemma, gcase))
      rescue
        ''
      end

      if inflection == word
        correct[[gender, gcase]] += 1
      else
        errors << [lemma, word, inflection, grammemes, [gender, gcase]]
      end

      total[[gender, gcase]] += 1
    end
  end

  total.each do |(gender, gcase), correct_count|
    precision = correct[[gender, gcase]] / correct_count.to_f * 100
    puts "\tPr(%s|%s) = %.4f%%" % [gcase, gender, precision]
  end

  correct_size = correct.values.inject(&:+)
  total_size = total.values.inject(&:+)
  puts 'Well, the precision on %d examples is about %.4f%%.' %
    [total_size, (correct_size / total_size.to_f * 100)]
end
