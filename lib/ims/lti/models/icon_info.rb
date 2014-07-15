module IMS::LTI::Models
  class IconInfo < LTIModel
    add_attributes :key, :icon_style
    add_attribute :default_location, relation: 'IMS::LTI::Models::IconEndpoint'
  end
end
