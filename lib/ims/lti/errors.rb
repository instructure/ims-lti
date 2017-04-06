module IMS::LTI
  module Errors
    require_relative 'errors/invalid_lti_config_error'
    require_relative 'errors/tool_proxy_registration_error'
    require_relative 'errors/invalid_tool_consumer_profile'
    require_relative 'errors/authentication_failed_error'
    require_relative 'errors/message_invalid_for_service'
  end
end
