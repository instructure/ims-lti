module IMS::LTI::Models
  class ServiceOwner < LTIModel
    add_attribute :description, relation: 'IMS::LTI::Models::LocalizedText'
    add_attribute :timestamp, json_converter:'IMS::LTI::Converters::TimeJSONConverter'
    add_attribute :service_owner_name, relation: 'IMS::LTI::Models::LocalizedName'

  end
end