module IMS::LTI::Serializers::MembershipService
  class LISPersonSerializer < IMS::LTI::Serializers::Base
    set_attribute :id, key: :@id
    set_attributes :name, :img, :email
    set_attribute :family_name, key: :familyName
    set_attribute :given_name, key: :givenName
    set_attribute :result_sourced_id, key: :resultSourcedId
    set_attribute :sourced_id, key: :sourcedId
    set_attribute :user_id, key: :userId
  end
end
