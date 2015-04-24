module IMS::LTI::Models::Messages
  class RequestMessage < Message

    add_recommended_params :user_id, :roles, :launch_presentation_document_target, :launch_presentation_width, :launch_presentation_height
    add_optional_params :launch_presentation_locale, :launch_presentation_css_url

    def initialize(attrs = {})
      super(attrs)
    end

  end
end