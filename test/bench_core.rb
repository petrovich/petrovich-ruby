require 'minitest/autorun'
require 'minitest/benchmark'
require 'petrovich'

module MockBenchmark
  module Settings
    def bench_range
      [20, 80, 320, 1280]
    end

    def run(*)
      puts 'Running ' + self.name
      super
    end
  end

  def self.included(base)
    base.extend Settings
  end

  def result_code
    ''
  end
end

class Petrovich::Benchmark < Minitest::Benchmark
  include MockBenchmark

  def bench_dative_to_s
    assert_performance_linear 0.99 do |n|
      n.times do
        Petrovich(
          lastname: 'Салтыков-Щедрин',
          firstname: 'Михаил',
          middlename: 'Евграфович',
        ).dative.to_s
      end
    end
  end
end
