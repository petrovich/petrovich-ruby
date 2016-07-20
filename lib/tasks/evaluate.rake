# encoding: utf-8

require 'csv'

def check!(errors, correct, total, lemma, gender, gcase, expected)
  petrovich = Petrovich(lastname: lemma, gender: gender)
  actual = Petrovich::Unicode.upcase(petrovich.public_send(gcase).lastname)
  total[[gender, gcase]] += 1
  if actual == expected
    correct[[gender, gcase]] += 1
    true
  else
    errors << [lemma, expected, actual, [gender, gcase]]
    actual
  end
end

desc 'Evaluate the inflector on lastnames'
task :evaluate => :petrovich do
  filename = File.expand_path('../../../eval/surnames.tsv', __FILE__)
  errors_filename = ENV['errors'] || 'errors.tsv'

  correct, total = Hash.new(0), Hash.new(0)

  puts 'I will evaluate the inflector on "%s" ' \
       'and store errors to "%s".' % [filename, errors_filename]

  CSV.open(errors_filename, 'w', col_sep: "\t") do |errors|
    errors << %w(lemma expected actual params)

    CSV.open(filename, "r:BINARY", col_sep: "\t", headers: true).each do |row|
      word = row['word'].force_encoding('UTF-8')
      lemma = row['lemma'].force_encoding('UTF-8')

      grammemes = if row['grammemes']
        row['grammemes'].force_encoding('UTF-8').split(',')
      else
        []
      end

      gender = grammemes.include?('мр') ? :male : :female

      if grammemes.include? '0'
        # some words are aptotic so we have to ensure that
        Petrovich::CASES.each do |gcase|
          check!(errors, correct, total, lemma, gender, gcase, word)
        end
      elsif grammemes.include? 'им'
        check!(errors, correct, total, lemma, gender, :nominative, word)
      elsif grammemes.include? 'рд'
        check!(errors, correct, total, lemma, gender, :genitive, word)
      elsif grammemes.include? 'дт'
        check!(errors, correct, total, lemma, gender, :dative, word)
      elsif grammemes.include? 'вн'
        check!(errors, correct, total, lemma, gender, :accusative, word)
      elsif grammemes.include? 'тв'
        check!(errors, correct, total, lemma, gender, :instrumental, word)
      elsif grammemes.include? 'пр'
        check!(errors, correct, total, lemma, gender, :prepositional, word)
      end
    end
  end

  total.each do |(gender, gcase), correct_count|
    accuracy = correct[[gender, gcase]] / correct_count.to_f * 100
    puts "\tAc(%s|%s) = %.4f%%" % [gcase, gender, accuracy]
  end

  correct_size = correct.values.inject(&:+)
  total_size = total.values.inject(&:+)

  puts 'Well, the accuracy on %d examples is about %.4f%%.' %
    [total_size, (correct_size / total_size.to_f * 100)]

  puts 'Sum of the %d correct examples and %d mistakes is %d.' %
    [correct_size, total_size - correct_size, total_size]
end

desc 'Evaluate gender detector'
task :detect => :petrovich do
  GENDER_MAP = { 'мр' => :male, 'жр' => :female, 'мр-жр' => :androgynous }

  filename = File.expand_path('../../../eval/surnames.gender.tsv', __FILE__)
  errors_filename = ENV['errors'] || 'errors.gender.tsv'

  correct, total = Hash.new(0), Hash.new(0)

  puts 'I will evaluate gender detector on "%s" ' \
       'and store errors to "%s".' % [filename, errors_filename]

  CSV.open(errors_filename, 'w', col_sep: "\t") do |errors|
    errors << %w(lemma expected actual)

    CSV.open(filename, "r:BINARY", col_sep: "\t", headers: true).each do |row|
      lemma = row['lemma'].force_encoding('UTF-8')
      gender_name = row['gender'].force_encoding('UTF-8')
      expected_gender = GENDER_MAP[gender_name]

      detected_gender = Petrovich(lastname: lemma).gender

      total[expected_gender] += 1
      if detected_gender == expected_gender
        correct[expected_gender] += 1
      else
        errors << [lemma, expected_gender, detected_gender]
      end
    end
  end

  total.each do |gender, correct_count|
    accuracy = correct[gender] / correct_count.to_f * 100
    puts "\tAc(%s) = %.4f%%" % [gender, accuracy]
  end

  correct_size = correct.values.inject(&:+)
  total_size = total.values.inject(&:+)

  puts 'Well, the accuracy on %d examples is about %.4f%%.' %
    [total_size, (correct_size / total_size.to_f * 100)]

  puts 'Sum of the %d correct examples and %d mistakes is %d.' %
    [correct_size, total_size - correct_size, total_size]
end
