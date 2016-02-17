module IMS::LTI::Serializers::MembershipService
  class MembershipSerializer < IMS::LTI::Serializers::Base
    attribute :id, key: :@id
    attributes :status, :role
    has_serializable :member
  end
end
