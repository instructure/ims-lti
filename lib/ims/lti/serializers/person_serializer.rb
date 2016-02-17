module IMS::LTI::Serializers
  class PersonSerializer
    def as_json
      h = super
      h.merge({
        :familyName => @obj.family_name,
        :name => @obj.name,
        :img => @obj.img,
        :givenName => @obj.given_name
      })
    end
  end
end
