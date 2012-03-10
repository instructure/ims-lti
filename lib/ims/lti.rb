require 'oauth'
require 'builder'
require "rexml/document"
require 'uuid'
require 'cgi'

module IMS
  module LTI
    VERSIONS = %w{1.0 1.1}
    
    class InvalidLTIConfigError < StandardError
    end
    
    def self.generate_identifier
      UUID.new
    end

    def self.valid_request?(secret, request, handle_error=true)
      begin
        signature = OAuth::Signature.build(request, :consumer_secret => secret)
        signature.verify() or raise OAuth::Unauthorized
        true
      rescue OAuth::Signature::UnknownSignatureMethod, OAuth::Unauthorized
        if handle_error
          false
        else
          raise $!
        end
      end
    end

  end
end

require 'ims/lti/launch_params'
require 'ims/lti/tool_provider'
require 'ims/lti/tool_consumer'
require 'ims/lti/outcome_request'
require 'ims/lti/outcome_response'
require 'ims/lti/tool_config'
