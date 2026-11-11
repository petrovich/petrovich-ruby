# encoding: utf-8

# Optional line coverage for MRI, enabled with COVERAGE=1.
#
# Require this file before minitest/autorun and petrovich: Coverage.start has
# to see the library load. The report is collected in Minitest.after_run,
# which runs after all tests have finished. On JRuby and TruffleRuby the
# helper does nothing, because Coverage requires special flags there.
if ENV['COVERAGE'] && RUBY_ENGINE == 'ruby'
  require 'coverage'
  require 'fileutils'
  require 'json'
  require 'minitest'

  Coverage.start(lines: true)

  module CoverageHelper
    ROOT = File.expand_path('..', __dir__)

    LIB_FILE = File.join(ROOT, 'lib', 'petrovich.rb').freeze
    LIB_DIR = (File.join(ROOT, 'lib', 'petrovich') + File::SEPARATOR).freeze
    TASKS_DIR = (File.join(ROOT, 'lib', 'tasks') + File::SEPARATOR).freeze

    module_function

    def stats(lines)
      covered = 0
      executable = 0
      uncovered = []

      lines.each_with_index do |count, index|
        next if count.nil?

        executable += 1
        if count > 0
          covered += 1
        else
          uncovered << index + 1
        end
      end

      percent = executable.zero? ? 100.0 : covered * 100.0 / executable

      {
        covered: covered,
        executable: executable,
        percent: percent,
        uncovered: uncovered
      }
    end

    def collect(result)
      threshold = []
      tasks = []

      result.each do |path, data|
        lines = data.is_a?(Hash) ? data[:lines] : data
        next unless lines

        path = File.expand_path(path)
        entry = [path, stats(lines)]

        if path == LIB_FILE || path.start_with?(LIB_DIR)
          threshold << entry
        elsif path.start_with?(TASKS_DIR)
          tasks << entry
        end
      end

      [threshold.sort_by(&:first), tasks.sort_by(&:first)]
    end

    def summarize(entries)
      covered = entries.inject(0) { |sum, (_, stat)| sum + stat[:covered] }
      executable = entries.inject(0) { |sum, (_, stat)| sum + stat[:executable] }
      percent = executable.zero? ? 100.0 : covered * 100.0 / executable

      { covered: covered, executable: executable, percent: percent }
    end

    def print_entry(path, stat, counted = true)
      relative = path.sub("#{ROOT}#{File::SEPARATOR}", '')
      suffix = counted ? '' : ' (not counted)'

      puts format('%-58s %6.2f%% (%d/%d)%s',
                  relative, stat[:percent], stat[:covered],
                  stat[:executable], suffix)

      return if stat[:uncovered].empty?

      puts "  uncovered lines: #{stat[:uncovered].join(', ')}"
    end

    def to_h(entries)
      entries.each_with_object({}) do |(path, stat), hash|
        relative = path.sub("#{ROOT}#{File::SEPARATOR}", '')

        hash[relative] = {
          'covered' => stat[:covered],
          'executable' => stat[:executable],
          'percent' => stat[:percent],
          'uncovered' => stat[:uncovered]
        }
      end
    end

    def write_report(threshold, tasks, summary, minimum)
      directory = File.join(ROOT, 'coverage')
      FileUtils.mkdir_p(directory)

      report = {
        'minimum' => minimum,
        'total' => {
          'covered' => summary[:covered],
          'executable' => summary[:executable],
          'percent' => summary[:percent]
        },
        'files' => to_h(threshold),
        'tasks' => to_h(tasks)
      }

      File.write(File.join(directory, 'coverage.json'),
                 JSON.pretty_generate(report))
    end

    def run
      threshold, tasks = collect(Coverage.result)
      summary = summarize(threshold)
      minimum = ENV.fetch('COVERAGE_MIN', '95').to_f

      puts
      puts 'Line coverage report:'

      threshold.each { |path, stat| print_entry(path, stat) }
      tasks.each { |path, stat| print_entry(path, stat, false) }

      puts format('Total: %.2f%% (%d/%d lines), minimum %.2f%%',
                  summary[:percent], summary[:covered],
                  summary[:executable], minimum)

      write_report(threshold, tasks, summary, minimum)

      return if summary[:percent] >= minimum

      warn format('Coverage %.2f%% is below the %.2f%% minimum',
                  summary[:percent], minimum)
      exit 1
    end
  end

  Minitest.after_run { CoverageHelper.run }
end
