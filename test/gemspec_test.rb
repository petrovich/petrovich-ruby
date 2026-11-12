# encoding: utf-8
require_relative 'test_helper'

describe 'petrovich.gemspec' do
  before do
    @spec = Dir.chdir(File.expand_path('..', __dir__)) do
      Gem::Specification.load('petrovich.gemspec')
    end
  end

  it 'loads' do
    refute_nil @spec
  end

  it 'packages the CLI' do
    assert_includes @spec.files, 'bin/petrovich'
    assert_equal ['petrovich'], @spec.executables
  end

  it 'packages rules and metadata' do
    %w[rules/rules.yml rules/gender.yml MIT-LICENSE Rakefile README.md CHANGELOG.md].each do |file|
      assert_includes @spec.files, file
    end
  end

  it 'uses the library version' do
    assert_equal Petrovich::VERSION, @spec.version.to_s
  end

  it 'requires an old enough Ruby' do
    assert_equal '>= 1.9.3', @spec.required_ruby_version.to_s
  end

  it 'declares development dependencies' do
    names = @spec.development_dependencies.map(&:name)

    %w[rake minitest csv].each do |name|
      assert_includes names, name
    end
  end
end
