Gem::Specification.new do |s|
  s.name = %q{ims-lti}
  s.version = "1.0"

  s.authors = ["Instructure"]
  s.date = %q{2012-03-10}
  s.extra_rdoc_files = %W(LICENSE)
  s.files = %W(
          LICENSE
          README.md
          lib/ims.rb
          lib/ims/lti.rb
          lib/ims/lti/launch_params.rb
          lib/ims/lti/outcome_request.rb
          lib/ims/lti/outcome_response.rb
          lib/ims/lti/tool_config.rb
          lib/ims/lti/tool_consumer.rb
          lib/ims/lti/tool_provider.rb
          ims-lti.gemspec
)
  s.homepage = %q{http://github.com/instructure/ims-lti}
  s.require_paths = %W(lib)
  s.summary = %q{Ruby library for creating IMS LTI tool providers and consumers}
end
