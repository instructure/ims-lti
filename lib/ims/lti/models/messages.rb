module IMS::LTI::Models
  module Messages
    require_relative 'messages/message'
    require_relative 'messages/request_message'
    require_relative 'messages/registration_request'
    require_relative 'messages/basic_lti_launch_request'
    require_relative 'messages/content_item_selection_request'
    require_relative 'messages/content_item_selection'
    require_relative 'messages/tool_proxy_reregistration_request'
  end
end