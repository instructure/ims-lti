module IMS::LTI::Serializers::MembershipService
  class PersonSerializer < IMS::LTI::Serializers::Base
    attribute :id, key: :@id
    attributes :name, :image
    attribute :family_name, key: :familyName
    attribute :given_name, key: :givenName
  end
end
