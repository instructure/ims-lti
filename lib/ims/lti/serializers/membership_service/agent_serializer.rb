module IMS::LTI::Serializers::MembershipService
  class AgentSerializer < IMS::LTI::Serializers::Base
    set_attribute :id, key: :@id
  end
end
