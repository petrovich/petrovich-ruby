# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "petrovich"
  s.version     = "1.0.0"
  s.authors     = ["Andrew Kozlov", "Dmitry Ustalov"]
  s.email       = ["demerest@gmail.com", "dmitry@eveel.ru"]
  s.homepage    = "https://github.com/petrovich/petrovich-ruby"
  s.summary     = 'Automatic inflection of Russian anthroponyms'
  s.description = 'A library to inflect Russian anthroponyms such as first names, last names, and middle names. Also it has gender detection functionality.'
  s.license     = 'MIT'

  s.required_ruby_version = ">= 1.9.3"
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.files = Dir["{lib}/**/*"] + ["rules/rules.yml"] + ["MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "commander", "4.3.5"
  s.add_development_dependency "bundler", "~> 1.7"
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "minitest"
  s.add_development_dependency "minitest-reporters"
end
