# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bfs_brute_force/version'

Gem::Specification.new do |spec|
  spec.name          = "bfs_brute_force"
  spec.version       = BfsBruteForce::VERSION
  spec.authors       = ["Joe Sortelli"]
  spec.email         = ["joe@sortelli.com"]
  spec.summary       = "Do a breadth first brute force search for solutions to puzzles"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
