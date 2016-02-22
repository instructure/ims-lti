module IMS::LTI::Serializers::MembershipService
  class OrganizationSerializer < IMS::LTI::Serializers::Base
    set_attribute :id, key: :@id
    set_attribute :name
    set_attribute :type, key: :@type
    has_list_of_serializables :membership
  end
end
