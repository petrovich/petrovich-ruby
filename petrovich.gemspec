# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "petrovich"
  s.version     = "0.1.3"
  s.authors     = ["Andrew Kozloff", "Dmitry Ustalov"]
  s.email       = ["demerest@gmail.com", "dmitry@eveel.ru"]
  s.homepage    = "https://github.com/petrovich/petrovich-ruby"
  s.summary     = 'Automatic inflection of Russian anthroponyms'
  s.description = 'A library to inflect Russian anthroponyms such as first names, last names, and middle names.'
  s.license     = 'MIT'

  s.required_ruby_version = ">= 1.9.1"
  s.files = Dir["{lib}/**/*"] + ["rules/rules.yml"] + ["MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "unicode_utils", "~> 1.4"
  s.add_development_dependency "rspec"
  s.add_development_dependency "gem-release", "~> 0.4.1"
end
