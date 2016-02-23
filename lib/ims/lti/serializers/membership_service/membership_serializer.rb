module IMS::LTI::Serializers::MembershipService
  class MembershipSerializer < IMS::LTI::Serializers::Base
    set_attribute :id, key: :@id
    set_attributes :status, :role
    has_serializable :member
  end
end
