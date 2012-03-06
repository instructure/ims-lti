require 'oauth'
require 'builder'

module IMS
  module LTI
    VERSIONS = %w{1.0 1.1}
    
    class InvalidLTIConfigError < StandardError
    end
    
  end
end

require 'ims/lti/tool_provider'
require 'ims/lti/tool_config'
