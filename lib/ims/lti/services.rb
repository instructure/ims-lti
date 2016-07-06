module IMS::LTI
  module Services
    require_relative 'services/tool_proxy_registration_service'
    require_relative 'services/tool_config'
    require_relative 'services/tool_proxy_validator'
    require_relative 'services/message_authenticator'
  end
end