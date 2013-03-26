# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'network_rail/version'

Gem::Specification.new do |spec|
  spec.name          = "network_rail"
  spec.version       = NetworkRail::VERSION
  spec.authors       = ["Steve Lorek"]
  spec.email         = ["steve@stevelorek.com"]
  spec.description   = %q{Provides a Ruby wrapper for consuming Network Rail Data Feeds}
  spec.summary       = %q{Ruby wrapper for consuming Network Rail Data Feeds}
  spec.homepage      = "http://github.com/slorek/network_rail"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_runtime_dependency "stomp"
end
