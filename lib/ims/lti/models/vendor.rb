module IMS::LTI::Models
  class Vendor < LTIModel

    add_attributes :code, :website
    add_attribute :id, json_key:'@id'
    add_attribute :contact, relation:'IMS::LTI::Models::Contact'
    add_attribute :vendor_name, relation:'IMS::LTI::Models::LocalizedName'
    add_attribute :description, relation:'IMS::LTI::Models::LocalizedText'
    add_attribute :timestamp, json_converter: 'IMS::LTI::Converters::TimeJSONConverter'

    def create_vendor_name(name, key = 'vendor.name')
      @vendor_name = LocalizedName.new(name, key)
    end

    def create_description(name, key = 'vendor.description')
      @description = LocalizedText.new(name, key)
    end

    def default_name
      vendor_name && vendor_name.default_value
    end

    def default_description
      description && description.default_value
    end

  end
end