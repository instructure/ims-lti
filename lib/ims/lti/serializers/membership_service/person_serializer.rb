module IMS::LTI::Serializers::MembershipService
  class PersonSerializer < IMS::LTI::Serializers::Base
    set_attribute :id, key: :@id
    set_attributes :name, :img
    set_attribute :family_name, key: :familyName
    set_attribute :given_name, key: :givenName
  end
end
