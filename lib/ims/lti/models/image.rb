require 'active_support'

module Ims::Lti::Models
  class Image
    include ActiveModel::Model

    REQUIRED_ELEMENTS = %i[id]

    validates_presence_of *REQUIRED_ELEMENTS
    attr_accessor *REQUIRED_ELEMENTS
    attr_accessor :height,
                  :width
  end
end
