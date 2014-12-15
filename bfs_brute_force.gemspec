# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bfs_brute_force/version'

Gem::Specification.new do |spec|
  spec.name          = "bfs_brute_force"
  spec.version       = BfsBruteForce::VERSION
  spec.authors       = ["Joe Sortelli"]
  spec.email         = ["joe@sortelli.com"]
  spec.summary       = "Lazy breadth first brute force search for solutions to puzzles"
  spec.description   = %q{
    Provides an API for representing the initial state and allowed
    next states of a puzzle, reachable through user defined moves.
    The framework also provides a simple solver which will lazily
    evaluate all the states in a breadth first manner to find a
    solution state, returning the list of moves required to transition
    from the initial state to solution state.
  }
  spec.homepage      = "https://github.com/sortelli/bfs_brute_force"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.5"
end
