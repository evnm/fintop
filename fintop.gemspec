# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fintop/version'

Gem::Specification.new do |s|
  s.name          = 'fintop'
  s.version       = Fintop::VERSION
  s.authors       = ['Evan Meagher']
  s.email         = ['evan.meagher@gmail.com']
  s.summary       = %q{A top-like utility for monitoring Finagle services}
  s.description   = %q{Fintop is a top-like tool for monitoring Finagle services}
  s.license       = 'MIT'

  s.files         = `git ls-files -z`.split("\x0")
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.add_development_dependency 'bundler', '~> 1.5'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'test-unit', '~> 2.5'

  s.add_dependency 'json'
  s.add_dependency 'sys-proctable', '~> 0.9.4'
end
