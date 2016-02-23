module IMS::LTI::Serializers::MembershipService
  class ContextSerializer < IMS::LTI::Serializers::Base
    set_attribute :id, key: :@id
    set_attribute :name
    set_attribute :type, key: :@type
    set_attribute :context_id, key: :contextId
    has_list_of_serializables :membership
  end
end
