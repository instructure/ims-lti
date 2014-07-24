module IMS::LTI::Models
  class ResourceHandler < LTIModel
    add_attribute :resource_type, relation: 'IMS::LTI::Models::ResourceType'
    add_attribute :resource_name, relation: 'IMS::LTI::Models::LocalizedName'
    add_attribute :description, relation: 'IMS::LTI::Models::LocalizedText'
    add_attribute :message, relation: 'IMS::LTI::Models::MessageHandler'
    add_attribute :icon_info, relation: 'IMS::LTI::Models::IconInfo'

    def default_name
      resource_name && resource_name.default_value
    end

    def default_description
      description && description.default_value
    end

    def messages
      [*message]
    end

  end
end