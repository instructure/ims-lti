Gem::Specification.new do |s|
  s.name = %q{ims-lti}
  s.version = "1.1.12"

  s.add_dependency 'builder'
  s.add_dependency 'oauth', '>= 0.4.5'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'ruby-debug'

  s.authors = ["Instructure"]
  s.date = %q{2015-01-09}
  s.extra_rdoc_files = %W(LICENSE)
  s.license = 'MIT'
  s.files = Dir["{lib}/**/*"] + ["LICENSE", "README.md", "Changelog"]
  s.homepage = %q{http://github.com/instructure/ims-lti}
  s.require_paths = %W(lib)
  s.summary = %q{Ruby library for creating IMS LTI tool providers and consumers}
end
