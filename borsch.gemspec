# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "borsch/version"

Gem::Specification.new do |s|
  s.name        = "borsch"
  s.version     = Borsch::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Marjan Krekoten' (Мар'ян Крекотень)"]
  s.email       = ["krekoten@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Io on top of Ruby}
  s.description = %q{Just for fun}

  s.rubyforge_project = "borsch"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'rspec'
  s.add_dependency 'parslet'
end
