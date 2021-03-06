# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'test_rail_integration/version'

Gem::Specification.new do |spec|
  spec.name          = "test_rail_integration"
  spec.version       = TestRailIntegration::VERSION
  spec.authors       = ["Kirikami"]
  spec.email         = ["naumenko.ruslan@outlook.com"]
  spec.summary       = %q{Gem for integration between framework and TestRail API}
  spec.description   = %q{Setups status of tests into TestRail after each scenario}
  spec.homepage      = "https://github.com/Kirikami/test_rail_integration"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "thor", "~> 0.17"
  spec.add_development_dependency "fileutils", "~> 0.7"
end
