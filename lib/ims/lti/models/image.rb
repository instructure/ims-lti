module IMS::LTI::Models
  class Image < LTIModel
    add_attribute :id, json_key: '@id'
    add_attributes :height, :width

  end
end