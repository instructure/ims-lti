module IMS::LTI::Models
  class ProductFamily < LTIModel
    add_attributes :code
    add_attribute :id, json_key: '@id'
    add_attribute :vendor, relation: 'IMS::LTI::Models::Vendor'

  end
end