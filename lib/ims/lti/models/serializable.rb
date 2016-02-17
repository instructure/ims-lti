module IMS::LTI::Models
  module Serializable
    def as_json
      class_name = self.class.name.split('::').last
      Object.const_get("IMS::LTI::Serializers::#{class_name}Serializer").new(self).as_json
    end

    def to_json
      as_json.to_json
    end
  end
end
