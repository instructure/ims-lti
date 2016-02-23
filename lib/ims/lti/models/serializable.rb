module IMS::LTI::Models
  module Serializable
    def as_json(opts={})
      class_name = self.class.name.gsub(/^IMS::LTI::Models/, 'IMS::LTI::Serializers') + 'Serializer'
      Object.const_get(class_name).as_json(self)
    end

    def to_json
      as_json.to_json
    end
  end
end
