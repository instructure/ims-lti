module IMS::LTI::Serializers::MembershipService
  class ContainerSerializer < IMS::LTI::Serializers::Base
    attribute :membership_predicate, key: :membershipPredicate
    attribute :membership_subject, key: :membershipSubject
  end
end
