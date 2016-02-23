module IMS::LTI::Serializers
  class AgentSerializer
    def initialize(obj)
      @obj = obj
    end

    def as_json
      { :@id => @obj.id }
    end

    def to_json
      as_json.to_json
    end
  end
end
