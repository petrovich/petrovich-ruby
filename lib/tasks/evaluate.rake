# encoding: utf-8

require 'csv'

def check!(errors, correct, total, name, gender, gcase, expected)
  petrovich = Petrovich(name.merge(gender: gender))
  lemma = name.values.join(' ')
  actual = Petrovich::Unicode.upcase(petrovich.public_send(gcase).to_s)
  total[[gender, gcase]] += 1
  if actual == expected
    correct[[gender, gcase]] += 1
    true
  else
    errors << [lemma, expected, actual, [gender, gcase]]
    actual
  end
end

def figure_namepart(args)
  namepart_filename = args[:namepart] || "surnames"
  namepart_filename += 's' unless namepart_filename.end_with?('s')
  namepart_symbol = namepart_filename.chop.to_sym
  namepart_symbol = :lastname if namepart_symbol == :surname
  namepart_symbol = :middlename if namepart_symbol == :midname
  namepart_filename += ".#{args[:subset]}" if args[:subset]
  [namepart_filename, namepart_symbol]
end

desc 'Evaluate Petrovich'
task :evaluate, [:namepart, :subset] => [:'evaluate:rules', :'evaluate:gender']

namespace :evaluate do
  desc 'Evaluate the inflector on lastnames'
  task :rules, [:namepart, :subset] => :petrovich do |_, args|
    namepart_filename, namepart_symbol = figure_namepart(args)
    filename = File.expand_path("../../../eval/#{namepart_filename}.tsv", __FILE__)
    unless File.file?(filename)
      warn "File #{filename} not found, skipping task"
      next
    end
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
            check!(errors, correct, total, { namepart_symbol => lemma }, gender, gcase, word)
          end
        elsif grammemes.include? 'им'
          check!(errors, correct, total, { namepart_symbol => lemma }, gender, :nominative, word)
        elsif grammemes.include? 'рд'
          check!(errors, correct, total, { namepart_symbol => lemma }, gender, :genitive, word)
        elsif grammemes.include? 'дт'
          check!(errors, correct, total, { namepart_symbol => lemma }, gender, :dative, word)
        elsif grammemes.include? 'вн'
          check!(errors, correct, total, { namepart_symbol => lemma }, gender, :accusative, word)
        elsif grammemes.include? 'тв'
          check!(errors, correct, total, { namepart_symbol => lemma }, gender, :instrumental, word)
        elsif grammemes.include? 'пр'
          check!(errors, correct, total, { namepart_symbol => lemma }, gender, :prepositional, word)
        end
      end
    end

    total.each do |(gender, gcase), correct_count|
      accuracy = correct[[gender, gcase]] / correct_count.to_f * 100
      puts "\tAc(%s|%s) = %.4f%%" % [gcase, gender, accuracy]
    end

    correct_size = correct.values.inject(&:+).to_i
    total_size = total.values.inject(&:+).to_i

    puts 'Well, the accuracy on %d examples is about %.4f%%.' %
      [total_size, (correct_size / total_size.to_f * 100)]

    puts 'Sum of the %d correct examples and %d mistakes is %d.' %
      [correct_size, total_size - correct_size, total_size]
  end

  desc 'Evaluate the gender detector'
  task :gender, [:namepart, :subset] => :petrovich do |_, args|
    GENDER_MAP = { 'мр' => :male, 'жр' => :female, 'мр-жр' => :androgynous }

    namepart_filename, namepart_symbol = figure_namepart(args)
    filename = File.expand_path("../../../eval/#{namepart_filename}.gender.tsv", __FILE__)
    unless File.file?(filename)
      warn "File #{filename} not found, skipping task"
      next
    end
    errors_filename = ENV['errors'] || 'errors.gender.tsv'

    correct, total = Hash.new(0), Hash.new(0)

    puts 'I will evaluate gender detector on "%s" ' \
         'and store errors to "%s".' % [filename, errors_filename]

    errors = []
    hard_error_count = 0

    CSV.open(filename, "r:BINARY", col_sep: "\t", headers: true).each do |row|
      lemma = row['lemma'].force_encoding('UTF-8')
      gender_name = row['gender'].force_encoding('UTF-8')
      expected_gender = GENDER_MAP[gender_name]

      detected_gender = Petrovich(namepart_symbol => lemma).gender

      total[expected_gender] += 1
      if detected_gender == expected_gender
        correct[expected_gender] += 1
      else
        errors << [lemma, expected_gender, detected_gender]
        if detected_gender != :androgynous
          hard_error_count += 1
          warn " - #{Petrovich::Unicode.downcase(lemma)}"
        end
      end
    end

    puts 'Hard error count: %d.' % [hard_error_count]

    PART_INDEX = {:female => 0, :male => 1, :androgynous => 3}
    errors.sort_by!{ |array| array.first.reverse + PART_INDEX[array[1]].to_s }

    CSV.open(errors_filename, 'w', col_sep: "\t") do |errors_file|
      errors_file << %w(lemma expected actual)
      errors.each do |array|
        errors_file << array
      end
    end

    total.each do |gender, correct_count|
      accuracy = correct[gender] / correct_count.to_f * 100
      puts "\tAc(%s) = %.4f%%" % [gender, accuracy]
    end

    correct_size = correct.values.inject(&:+).to_i
    total_size = total.values.inject(&:+).to_i

    puts 'Well, the accuracy on %d examples is about %.4f%%.' %
      [total_size, (correct_size / total_size.to_f * 100)]

    puts 'Sum of the %d correct examples and %d mistakes is %d.' %
      [correct_size, total_size - correct_size, total_size]
  end
end
