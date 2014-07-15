module IMS::LTI::Models
  class ServiceProvider < LTIModel
    add_attribute :guid
    add_attribute :id, json_key:'@id'
    add_attribute :service_provider_name, relation:'IMS::LTI::Models::LocalizedName'
    add_attribute :description, relation:'IMS::LTI::Models::LocalizedText'
    add_attribute :support, relation:'IMS::LTI::Models::Contact'
    add_attribute :timestamp, json_converter: 'IMS::LTI::Converters::TimeJSONConverter'

  end
end