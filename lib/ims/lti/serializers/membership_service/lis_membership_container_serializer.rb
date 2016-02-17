module IMS::LTI::Serializers::MembershipService
  class LISMembershipContainerSerializer < IMS::LTI::Serializers::Base
    attribute :membership_predicate, key: :membershipPredicate
    attribute :membership_subject, key: :membershipSubject
    attribute :id, key: :@id
    attribute :context, key: :@context
    attribute :type, key: :@type
  end
end
