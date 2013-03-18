# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'national_rail/version'

Gem::Specification.new do |spec|
  spec.name          = "national_rail"
  spec.version       = NationalRail::VERSION
  spec.authors       = ["Steve Lorek"]
  spec.email         = ["steve@stevelorek.com"]
  spec.description   = %q{Provides a Ruby wrapper for consuming National Rail Data Feeds}
  spec.summary       = %q{Ruby wrapper for consuming National Rail Data Feeds}
  spec.homepage      = "http://github.com/slorek/national_rail"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
