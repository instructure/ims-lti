module IMS::LTI::Serializers::MembershipService
  class ContextSerializer < IMS::LTI::Serializers::Base
    attribute :id, key: :@id
    attribute :name
    attribute :type, key: :@type
    attribute :context_id, key: :contextId
    has_list_of_serializables :membership
  end
end
