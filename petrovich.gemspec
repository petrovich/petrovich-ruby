# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'petrovich'
  s.version     = '1.0.1'
  s.authors     = ['Andrew Kozlov', 'Dmitry Ustalov']
  s.email       = ['demerest@gmail.com', 'dmitry.ustalov@gmail.com']
  s.homepage    = 'https://github.com/petrovich/petrovich-ruby'
  s.summary     = 'Petrovich, an inflector for Russian anthroponyms.'
  s.description = 'A morphological library for Russian anthroponyms, such as first names, last names, and middle names.'
  s.license     = 'MIT'

  s.required_ruby_version = '>= 1.9.3'
  s.executables = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.files = Dir['{lib}/**/*'] + ['rules/rules.yml'] + ['MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'commander', '4.3.5'
  s.add_development_dependency 'rake', '~> 10.0'
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'minitest-reporters'
end
