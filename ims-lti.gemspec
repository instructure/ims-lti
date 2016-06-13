# coding: utf-8
# lib = File.expand_path('../lib', __FILE__)
# $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'ims-lti'
  spec.version       = '2.0.0.beta.41'
  spec.authors       = ['Instructure']
  spec.summary       = %q{Ruby library for creating IMS LTI tool providers and consumers}
  spec.homepage      = %q{http://github.com/instructure/ims-lti}
  spec.license       = 'MIT'

  spec.files         = Dir['{lib}/**/*'] + ['LICENSE.txt', 'README.md', 'Changelog.txt']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'simple_oauth', '0.2'
  spec.add_dependency 'faraday', '~> 0.8'
  spec.add_dependency 'faraday_middleware', '~> 0.8'
  spec.add_dependency 'builder'

  spec.add_development_dependency 'rake', '~> 10.4.2'
  spec.add_development_dependency 'rspec', '~> 3.2.0'
  spec.add_development_dependency 'guard', '~> 2.13.0'
  spec.add_development_dependency 'guard-rspec', '~> 4.6.4'
  spec.add_development_dependency 'listen', '~> 2.10.1'
  spec.add_development_dependency 'pry', '~> 0.10.1'
  spec.add_development_dependency 'byebug', '~> 8.2'

end
