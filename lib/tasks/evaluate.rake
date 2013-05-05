# encoding: utf-8

require 'csv'

CASES = [
  :nominative,
  :genitive,
  :dative,
  :accusative,
  :instrumentative,
  :prepositional
]

def check!(correct, total, lemma, gender, gcase, expected)
  inflector = Petrovich.new(gender)
  inflection = begin
    UnicodeUtils.upcase(inflector.lastname(lemma, gcase))
  rescue
    ''
  end

  total[[gender, gcase]] += 1

  if inflection == expected
    correct[[gender, gcase]] += 1
    true
  else
    inflection
  end
end

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

      gender = grammemes.include?('мр') ? :male : :female

      if grammemes.include? '0'
        # some words are aptotic so we have to ensure that
        CASES.each { |c| check! correct, total, lemma, gender, c, word }
      elsif grammemes.include? 'им'
        check! correct, total, lemma, gender, :nominative, word
      elsif grammemes.include? 'рд'
        check! correct, total, lemma, gender, :genitive, word
      elsif grammemes.include? 'дт'
        check! correct, total, lemma, gender, :dative, word
      elsif grammemes.include? 'вн'
        check! correct, total, lemma, gender, :accusative, word
      elsif grammemes.include? 'тв'
        # actually, it's called the instrumetal case
        check! correct, total, lemma, gender, :instrumentative, word
      elsif grammemes.include? 'пр'
        check! correct, total, lemma, gender, :prepositional, word
      end
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
