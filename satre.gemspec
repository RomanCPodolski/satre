# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'satre/version'

Gem::Specification.new do |spec|
  spec.name          = 'satre'
  spec.version       = Satre::VERSION
  spec.authors       = ['Roman C. Podolski']
	spec.email         = ['roman.podolski@tum.de']

  spec.summary       = %q{A propositional and first order logic library}
  spec.description   = %q{
  I think therefore I am.
  
  Satre is a library for proportional and first order logic.
  It was inspired by the book 'Handbook of practical logic and automated reasoning' by Harrison, J (2009).
  
  This project originated at the Technical university munich as a students project in the lecture 'Basics of Artificial Intelligence'.
  }
  spec.homepage      = "http://in.tum.de"
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'terminal-table'
  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'guard-bundler'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'guard-minitest'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'guard-rubocop'
  spec.add_development_dependency 'codeclimate-test-reporter'
end
