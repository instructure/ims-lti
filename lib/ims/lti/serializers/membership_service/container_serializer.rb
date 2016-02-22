module IMS::LTI::Serializers::MembershipService
  class ContainerSerializer < IMS::LTI::Serializers::Base
    set_attribute :membership_predicate, key: :membershipPredicate
    has_serializable :membership_subject, key: :membershipSubject
  end
end
