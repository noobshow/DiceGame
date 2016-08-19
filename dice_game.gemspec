# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dice_game/version'

Gem::Specification.new do |spec|
  spec.name          = "DiceGame"
  spec.version       = DiceGame::VERSION
  spec.authors       = ["Sujay Sudheendra"]
  spec.email         = ["sujaysudheendra@gmail.com"]
  spec.summary       = %q{A simple dice game.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test)/}) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = Dir['spec/**/*']
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_runtime_dependency 'thor', '~> 0.19'
end
