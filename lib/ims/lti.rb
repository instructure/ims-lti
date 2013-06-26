require 'oauth'
require 'builder'
require "rexml/document"
require 'uuid'
require 'cgi'

module IMS # :nodoc:

  # :main:IMS::LTI
  # LTI is a standard defined by IMS for creating eduction Tool Consumers/Providers.
  # LTI documentation: http://www.imsglobal.org/lti/index.html
  #
  # When creating these tools you will work primarily with the ToolProvider and
  # ToolConsumer classes.
  #
  # For validating OAuth request be sure to require the necessary proxy request
  # object. See IMS::LTI::RequestValidator#valid_request? for more documentation.
  #
  # == Installation
  # This is packaged as the `ims-lti` rubygem, so you can just add the dependency to
  # your Gemfile or install the gem on your system:
  #
  #    gem install ims-lti
  #
  # To require the library in your project:
  #
  #    require 'ims/lti'
  module LTI
    
    # The versions of LTI this library supports
    VERSIONS = %w{1.0 1.1}
    
    class InvalidLTIConfigError < StandardError
    end

    # Generates a unique identifier
    def self.generate_identifier
      UUID.new.generate
    end
  end
end

require 'ims/lti/extensions'
require 'ims/lti/launch_params'
require 'ims/lti/request_validator'
require 'ims/lti/tool_provider'
require 'ims/lti/tool_consumer'
require 'ims/lti/outcome_request'
require 'ims/lti/outcome_response'
require 'ims/lti/tool_config'
