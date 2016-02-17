module IMS::LTI::Serializers
  class ContainerSerializer
    def initialize(obj)
      @obj = obj
    end

    def as_json
      h = {}
      h[:membershipSubject] = @obj.membership_subject ? @obj.membership_subject.as_json : nil
      h[:membershipPredicate] = @obj.membership_predicate
      h
    end

    def to_json
      as_json.to_json
    end
  end
end
