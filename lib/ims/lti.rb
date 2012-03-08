require 'oauth'
require 'builder'
require "rexml/document"
require 'uuid'

module IMS
  module LTI
    VERSIONS = %w{1.0 1.1}
    
    class InvalidLTIConfigError < StandardError
    end
    
    def self.generate_identifier
      UUID.new
    end
    
  end
end

require 'ims/lti/tool_provider'
require 'ims/lti/outcome_request'
require 'ims/lti/outcome_response'
require 'ims/lti/tool_config'
