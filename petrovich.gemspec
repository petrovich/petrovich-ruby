# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "petrovich"
  s.version     = "0.0.7"
  s.authors     = ["Andrew Kozloff"]
  s.email       = ["demerest@gmail.com"]
  s.homepage    = "https://github.com/rocsci/petrovich"
  s.summary     = "Склонение падежей русских имён, фамилий и отчеств"
  s.description = "Вы задаёте начальное имя в именительном падеже, а получаете в нужном вам"

  s.required_ruby_version = ">= 1.9.1"
  s.files = Dir["{lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "unicode_utils", "1.4.0"
  s.add_development_dependency "rspec"
  s.add_development_dependency "gem-release", "~> 0.4.1"
end
