# encoding: utf-8
require_relative 'test_helper'
require 'rake'

# The Rakefile imports the task file before the tests run, so load it only
# when the test is executed directly. Loading it twice would register the
# task actions twice.
unless Rake::Task.task_defined?('evaluate:rules')
  load File.expand_path('../lib/tasks/evaluate.rake', __dir__)
end

describe 'lib/tasks/evaluate.rake' do
  def counters
    [Hash.new(0), Hash.new(0)]
  end

  describe 'figure_namepart' do
    it 'defaults to surnames and lastname' do
      assert_equal ['surnames', :lastname], figure_namepart({})
    end

    it 'turns surname into lastname' do
      assert_equal ['surnames', :lastname], figure_namepart(namepart: 'surname')
    end

    it 'keeps lastname as is' do
      assert_equal ['lastnames', :lastname], figure_namepart(namepart: 'lastname')
    end

    it 'keeps firstname as is' do
      assert_equal ['firstnames', :firstname], figure_namepart(namepart: 'firstname')
    end

    it 'turns midname into middlename' do
      assert_equal ['midnames', :middlename], figure_namepart(namepart: 'midname')
    end

    it 'keeps middlename as is' do
      assert_equal ['middlenames', :middlename], figure_namepart(namepart: 'middlename')
    end

    it 'does not double the plural suffix' do
      assert_equal ['surnames', :lastname], figure_namepart(namepart: 'surnames')
    end

    it 'appends a subset to the file name' do
      assert_equal ['surnames.misc', :lastname], figure_namepart(namepart: 'surname', subset: 'misc')
    end

    it 'appends a subset to a name part without a suffix' do
      assert_equal ['firstnames.misc', :firstname], figure_namepart(namepart: 'firstname', subset: 'misc')
    end
  end

  describe 'check!' do
    it 'returns true and counts a correct answer' do
      errors = []
      correct, total = counters

      result = check!(errors, correct, total, { lastname: 'Иванов' }, :male, :dative, 'ИВАНОВУ')

      assert_equal true, result
      assert_equal 1, correct[[:male, :dative]]
      assert_equal 1, total[[:male, :dative]]
      assert_empty errors
    end

    it 'returns the actual value and records an error' do
      errors = []
      correct, total = counters

      result = check!(errors, correct, total, { lastname: 'Иванов' }, :male, :dative, 'ИВАНОВ')

      assert_equal 'ИВАНОВУ', result
      assert_equal 0, correct[[:male, :dative]]
      assert_equal 1, total[[:male, :dative]]
      assert_equal [['Иванов', 'ИВАНОВ', 'ИВАНОВУ', [:male, :dative]]], errors
    end

    it 'counts every gender and case separately' do
      errors = []
      correct, total = counters

      check!(errors, correct, total, { lastname: 'Иванов' }, :male, :dative, 'ИВАНОВУ')
      check!(errors, correct, total, { lastname: 'Иванова' }, :female, :dative, 'ИВАНОВОЙ')

      assert_equal 1, correct[[:male, :dative]]
      assert_equal 1, correct[[:female, :dative]]
      assert_equal 1, total[[:male, :dative]]
      assert_equal 1, total[[:female, :dative]]
      assert_empty errors
    end
  end
end
