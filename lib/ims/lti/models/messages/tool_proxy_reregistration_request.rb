module IMS::LTI::Models::Messages
  class ToolProxyReregistrationRequest < RequestMessage

    add_required_params :tc_profile_url, :launch_presentation_return_url


    MESSAGE_TYPE = 'ToolProxyReregistrationRequest'

    def initialize(attrs = {})
      super(attrs)
      self.lti_message_type = MESSAGE_TYPE
    end

  end
end