require 'active_model'

module Ims::Lti::Models
  # Class represeting a Content-item
  class ContentItem
    include ActiveModel::Model
    include Ims::Lti::Concerns::TypedAttributes

    REQUIRED_ELEMENTS = %i[
      mediaType
    ].freeze

    TYPED_ATTRIBUTES = {
      icon: Ims::Lti::Models::Image,
      thumbnail: Ims::Lti::Models::Image
    }.freeze

    validates_presence_of *REQUIRED_ELEMENTS
    attr_accessor *REQUIRED_ELEMENTS
    attr_accessor :type,
                  :id,
                  :url,
                  :title,
                  :icon,
                  :thumbnail,
                  :text,
                  :custom,
                  :copyAdvice,
                  :expiresAt,
                  :presentationDocumentTarget,
                  :windowTarget,
                  :displayWidth,
                  :displayHeight

    validates_each TYPED_ATTRIBUTES.keys do |record, attr, value|
      type_error = validate_types(TYPED_ATTRIBUTES[attr], attr, value)
      record.errors.add attr, type_error unless type_error.nil?
    end
  end
end
