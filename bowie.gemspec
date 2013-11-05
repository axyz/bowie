# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bowie/version'

Gem::Specification.new do |spec|
  spec.name          = "bowie"
  spec.version       = Bowie::VERSION
  spec.authors       = ["Andrea Moretti"]
  spec.email         = ["axyzxp@gmail.com"]
  spec.description   = %q{A package manager for github's projects}
  spec.summary       = %q{The White Duke rules them all}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_runtime_dependency "git"
end
