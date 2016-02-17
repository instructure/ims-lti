module IMS::LTI::Serializers::MembershipService
  class AgentSerializer < IMS::LTI::Serializers::Base
    attribute :id, key: :@id
  end
end
