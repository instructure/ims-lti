module IMS::LTI::Serializers
  class LISPersonSerializer
    def as_json
      h = super
      h.merge({
        :email => @obj.email,
        :resultSourcedId => @obj.result_sourced_id,
        :sourcedId => @obj.sourced_id,
        :userId => @obj.user_id
      })
    end
  end
end
