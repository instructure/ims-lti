module IMS::LTI::Serializers::MembershipService
  class PageSerializer < IMS::LTI::Serializers::Base
    set_attribute :id, key: :@id
    set_attribute :type, key: :@type
    set_attribute :context, key: :@context
    set_attribute :differences
    set_attribute :next_page, key: :nextPage
    has_serializable :page_of, key: :pageOf
  end
end
