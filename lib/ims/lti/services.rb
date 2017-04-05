module IMS::LTI
  module Services
    require_relative 'services/oauth1_client'
    require_relative 'services/oauth2_client'
    require_relative 'services/tool_proxy_registration_service'
    require_relative 'services/tool_config'
    require_relative 'services/tool_proxy_validator'
    require_relative 'services/message_authenticator'
    require_relative 'services/authentication_service'
  end
end
