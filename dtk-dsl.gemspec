require File.expand_path('../lib/dsl/version', __FILE__)

Gem::Specification.new do |spec| 
  spec.name        = 'dtk-dsl' 
  spec.version     = DTK::DSL::VERSION
  spec.author      = 'Reactor8'
  spec.email       = 'support@reactor8.com'
  spec.description = %q{Library for parsing DT DSL files.}
  spec.summary     = %q{Library for parsing DT DSL files.}
  spec.license     = 'Apache 2.0'
  spec.platform    = Gem::Platform::RUBY
  spec.required_ruby_version = Gem::Requirement.new('>= 1.9.3')

  spec.require_paths = ['lib']
  spec.files =  `git ls-files`.split("\n")
end
