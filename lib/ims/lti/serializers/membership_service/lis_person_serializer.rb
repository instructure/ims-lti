module IMS::LTI::Serializers::MembershipService
  class LISPersonSerializer < IMS::LTI::Serializers::Base
    attribute :id, key: :@id
    attributes :name, :image, :email
    attribute :family_name, key: :familyName
    attribute :given_name, key: :givenName
    attribute :result_sourced_id, key: :resultSourcedId
    attribute :sourced_id, key: :sourcedId
    attribute :user_id, key: :userId
  end
end
