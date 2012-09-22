# -*- encoding: utf-8 -*-
require File.expand_path('../lib/brain/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Adam Watkins"]
  gem.email         = ["adam@stupidpupil.co.uk"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "brain"
  gem.require_paths = ["lib"]
  gem.version       = Brain::VERSION
  gem.licenses      = ["MIT"]

  gem.add_development_dependency "rspec", "~> 2.11"
end
