require 'active_support'

module Ims::Lti::Models
  # Class represeting an image for Content-item. This class
  # should be used for specifying the {thumbnail} and
  # {icon} attributes of {ContentItem}
  class Image
    include ActiveModel::Model

    REQUIRED_ELEMENTS = %i[id].freeze

    validates_presence_of *REQUIRED_ELEMENTS
    attr_accessor *REQUIRED_ELEMENTS
    attr_accessor :height,
                  :width
  end
end
