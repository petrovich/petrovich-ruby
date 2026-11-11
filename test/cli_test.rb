# encoding: utf-8
require_relative 'test_helper'
require 'open3'
require 'rbconfig'

describe 'bin/petrovich' do
  def root
    File.expand_path('..', __dir__)
  end

  def cli
    File.join(root, 'bin', 'petrovich')
  end

  def run_cli(*args)
    stdout, stderr, status = Open3.capture3(
      RbConfig.ruby, '-Ilib', cli, *args, chdir: root
    )

    [stdout.force_encoding(Encoding::UTF_8),
     stderr.force_encoding(Encoding::UTF_8),
     status]
  end

  def run_cli_in_process(*args)
    original = ARGV.dup
    ARGV.replace(args)
    yield
  ensure
    ARGV.replace(original)
  end

  def assert_cli_success(expected, *args)
    stdout, stderr, status = run_cli(*args)

    assert status.success?, "expected success, got #{status.exitstatus}: #{stderr}"
    assert_equal '', stderr
    assert_equal expected, stdout
  end

  def assert_cli_failure(message, *args)
    stdout, stderr, status = run_cli(*args)

    assert_equal 1, status.exitstatus
    assert_equal '', stdout
    assert_includes stderr, message
  end

  it 'inflects a full name in the accusative case' do
    assert_cli_success(
      "Иванова Ивана Ивановича\n",
      '-l', 'Иванов', '-f', 'Иван', '-m', 'Иванович',
      '-g', 'male', '-c', 'accusative'
    )
  end

  it 'prints the name and the gender with -n' do
    assert_cli_success(
      "Иванову Ивану Ивановичу\tmale\n",
      '-l', 'Иванов', '-f', 'Иван', '-m', 'Иванович', '-c', 'dative', '-n'
    )
  end

  it 'prints only the gender with -o' do
    assert_cli_success(
      "male\n",
      '-l', 'Иванов', '-f', 'Иван', '-m', 'Иванович', '-c', 'dative', '-o'
    )
  end

  it 'leaves a female lastname unchanged' do
    assert_cli_success(
      "Воробей\n",
      '-l', 'Воробей', '-g', 'female', '-c', 'dative'
    )
  end

  it 'inflects a male lastname' do
    assert_cli_success(
      "Воробью\n",
      '-l', 'Воробей', '-g', 'male', '-c', 'dative'
    )
  end

  it 'accepts an abbreviated case name' do
    assert_cli_success(
      "Иванову\n",
      '-l', 'Иванов', '-c', 'dat'
    )
  end

  it 'prints the version' do
    assert_cli_success(
      "Petrovich #{Petrovich::VERSION}\n",
      '--version'
    )
  end

  it 'prints the usage with --help' do
    stdout, stderr, status = run_cli('--help')

    assert status.success?
    assert_equal '', stderr
    assert stdout.start_with?('Usage:'), "unexpected help output: #{stdout}"
  end

  it 'rejects an unknown case' do
    assert_cli_failure('invalid argument', '-c', 'bogus')
  end

  it 'rejects an unknown gender' do
    # The short `-g` option takes an optional argument, so `-g bogus` leaves
    # "bogus" in ARGV instead of validating it. The long form does validate.
    assert_cli_failure('invalid argument', '--gender', 'bogus')
  end

  it 'rejects a call without a case' do
    assert_cli_failure('ArgumentError', '-l', 'Иванов')
  end

  it 'rejects a call without names' do
    assert_cli_failure('ArgumentError', '-c', 'dative')
  end

  it 'prints the version in-process' do
    error = nil
    stdout, stderr = run_cli_in_process('--version') do
      capture_io { error = assert_raises(SystemExit) { load cli } }
    end

    assert_equal 0, error.status
    assert_equal "Petrovich #{Petrovich::VERSION}\n", stdout
    assert_equal '', stderr
  end

  it 'prints the usage in-process' do
    error = nil
    stdout, stderr = run_cli_in_process('--help') do
      capture_io { error = assert_raises(SystemExit) { load cli } }
    end

    assert_equal 0, error.status
    assert stdout.start_with?('Usage:'), "unexpected help output: #{stdout}"
    assert_equal '', stderr
  end

  it 'prints only the gender in-process' do
    error = nil
    stdout, stderr = run_cli_in_process('-l', 'Иванов', '-o') do
      capture_io { error = assert_raises(SystemExit) { load cli } }
    end

    assert_equal 0, error.status
    assert_equal "male\n", stdout
    assert_equal '', stderr
  end

  it 'prints the name and the gender in-process' do
    stdout, stderr = run_cli_in_process('-l', 'Иванов', '-c', 'dative', '-n') do
      capture_io { load cli }
    end

    assert_equal "Иванову\tmale\n", stdout
    assert_equal '', stderr
  end

  it 'inflects a name in-process' do
    stdout, stderr = run_cli_in_process('-l', 'Иванов', '-c', 'dative') do
      capture_io { load cli }
    end

    assert_equal "Иванову\n", stdout
    assert_equal '', stderr
  end
end
