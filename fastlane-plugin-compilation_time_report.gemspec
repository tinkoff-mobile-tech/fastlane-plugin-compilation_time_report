# coding: utf-8

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/compilation_time_report/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-compilation_time_report'
  spec.version       = Fastlane::CompilationTimeReport::VERSION
  spec.author        = 'i.v.vasilenko'
  spec.email         = 'i.v.vasilenko@tinkoff.ru'

  spec.summary       = 'Generate custom HTML report compilation time of each Swift func'
  spec.homepage      = "https://github.com/TinkoffCreditSystems/fastlane-plugin-compilation_time_report"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency('pry')
  spec.add_development_dependency('bundler')
  spec.add_development_dependency('rspec')
  spec.add_development_dependency('rspec_junit_formatter')
  spec.add_development_dependency('rake')
  spec.add_development_dependency('rubocop', '0.49.1')
  spec.add_development_dependency('rubocop-require_tools')
  spec.add_development_dependency('simplecov')
  spec.add_development_dependency('fastlane', '>= 2.114.0')
end
