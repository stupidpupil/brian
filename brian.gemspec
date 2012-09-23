# -*- encoding: utf-8 -*-
require File.expand_path('../lib/brian/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Adam Watkins"]
  gem.email         = ["adam@stupidpupil.co.uk"]
  gem.description   = %q{A port of the brain.js library, implementing a multilayer perceptron - a neural network for supervised learning.}
  gem.summary       = %q{Multilayer perceptron (neural network) library.}
  gem.homepage      = "https://github.com/stupidpupil/brian"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "brian"
  gem.require_paths = ["lib"]
  gem.version       = Brian::VERSION
  gem.license       = "MIT"

  gem.add_development_dependency "rspec", "~> 2.11"
end
