require_relative 'concerns'

module Ims::Lti::Models
  class Image
    include Ims::Lti::Models::Concerns::SerializedParameters

    attr_accessor :height,
                  :id,
                  :width
  end
end