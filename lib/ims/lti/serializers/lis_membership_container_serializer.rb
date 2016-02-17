module IMS::LTI::Serializers
  class LISMembershipContainerSerializer
    def initialize(obj)
      @obj = obj
    end

    def as_json
      h = super
      h[:@context] = @obj.context
      h[:@id] = @obj.id
      h[:@type] = @obj.type
      h
    end

    def to_json
      as_json.to_json
    end
  end
end
