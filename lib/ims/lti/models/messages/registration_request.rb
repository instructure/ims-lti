module IMS::LTI::Models::Messages
  class RegistrationRequest < RequestMessage

    add_required_params :reg_key, :reg_password, :tc_profile_url, :launch_presentation_return_url


    MESSAGE_TYPE = 'ToolProxyRegistrationRequest'

    def initialize(attrs = {})
      super(attrs)
      self.lti_message_type = MESSAGE_TYPE
    end

    def generate_key_and_password
      self.reg_key, self.reg_password = 2.times.map { SecureRandom.uuid }
    end

  end
end