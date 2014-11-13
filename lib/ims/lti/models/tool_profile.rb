module IMS::LTI::Models
  class ToolProfile < LTIModel
    add_attributes :lti_version
    add_attribute :id, json_key: '@id'
    add_attribute :product_instance, relation:'IMS::LTI::Models::ProductInstance'
    add_attribute :base_url_choice, relation: 'IMS::LTI::Models::BaseUrlChoice'
    add_attribute :resource_handler, relation:'IMS::LTI::Models::ResourceHandler'
    add_attribute :message, relation:'IMS::LTI::Models::MessageHandler'
    add_attribute :service_offered, relation:'IMS::LTI::Models::RestService'


    def base_message_url
      if base_url_choice
        choice = base_url_choice.find { |choice| choice.default_message_url != '' }
        choice ? choice.default_message_url : ''
      else
        ''
      end
    end

    def resource_handlers
      [*@resource_handler]
    end

    def messages
      [*@message]
    end

  end
end