# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "petrovich"
  s.version     = "0.0.2"
  s.authors     = ["Andrew Kozloff"]
  s.email       = ["demerest@gmail.com"]
  s.homepage    = "https://github.com/tanraya/papillon"
  s.summary     = "Склонение падежей русских имён, фамилий и отчеств"
  s.description = "Вы задаёте начальное имя в именительном падеже, а получаете в нужном вам"

  s.files = Dir["{lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "unicode_utils", ">= 0.6.4"
  s.add_development_dependency "rspec"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "activerecord", ">= 3.2.12"
  s.add_development_dependency "gem-release", "~> 0.4.1"
end
