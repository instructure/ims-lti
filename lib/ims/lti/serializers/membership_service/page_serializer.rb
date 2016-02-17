module IMS::LTI::Serializers::MembershipService
  class PageSerializer < IMS::LTI::Serializers::Base
    attribute :id, key: :@id
    attribute :type, key: :@type
    attribute :context, key: :@context
    attribute :differences
    attribute :next_page, key: :nextPage
    has_serializable :page_of, key: :pageOf
  end
end
