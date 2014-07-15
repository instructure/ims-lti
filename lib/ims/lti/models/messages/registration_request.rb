module IMS::LTI::Models::Messages
  class RegistrationRequest < Message
    add_attributes :reg_key, :reg_password, :tc_profile_url, :launch_presentation_return_url

    REGISTRATION_REQUEST_MESSAGE_TYPE = 'ToolProxyRegistrationRequest'

    def initialize(attributes = {})
      super(attributes)
      self.lti_message_type = REGISTRATION_REQUEST_MESSAGE_TYPE
    end

    def generate_key_and_password
      self.reg_key, self.reg_password = 2.times.map { SecureRandom.uuid }
    end

  end
end