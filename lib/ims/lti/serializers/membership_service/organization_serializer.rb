module IMS::LTI::Serializers::MembershipService
  class OrganizationSerializer < IMS::LTI::Serializers::Base
    attribute :id, key: :@id
    attribute :name
    attribute :type, key: :@type
    has_list_of_serializables :membership
  end
end
