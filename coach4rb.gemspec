# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'coach4rb/version'

Gem::Specification.new do |spec|
  spec.name          = "coach4rb"
  spec.version       = Coach4rb::VERSION
  spec.authors       = ["Alexander Rueedlinger","Stefan Wanzenried","Roman Kuepper","Sveta Krasikova"]
  spec.email         = ["a.rueedlinger@gmail.com"]
  spec.summary       = %q{Coach4rb is client for the cyber coach webservice.}
  spec.description   = %q{Coach4rb is client for the cyber coach webservice @unifr.ch. }
  spec.homepage      = "https://github.com/lexruee/coach4rb"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"

  spec.add_runtime_dependency "rest-client"
  spec.add_runtime_dependency "addressable"
  spec.add_runtime_dependency "gyoku"
  spec.add_runtime_dependency "base64"
  spec.add_runtime_dependency "ostruct"

end
