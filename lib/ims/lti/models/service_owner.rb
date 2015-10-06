module IMS::LTI::Models
  class ServiceOwner < LTIModel
    add_attribute :id, json_key:'@id'
    add_attribute :description, relation: 'IMS::LTI::Models::LocalizedText'
    add_attribute :timestamp, json_converter:'IMS::LTI::Converters::TimeJSONConverter'
    add_attribute :service_owner_name, relation: 'IMS::LTI::Models::LocalizedName'
    add_attribute :support, relation:'IMS::LTI::Models::Contact'

    def create_service_owner_name(name, key = 'service_owner.name')
      @service_owner_name = LocalizedName.new(name, key)
    end

    def create_description(name, key = 'service_owner.description')
      @description = LocalizedText.new(name, key)
    end

    def default_name
      service_owner_name && service_owner_name.default_value
    end

    def default_description
      description && description.default_value
    end

  end
end