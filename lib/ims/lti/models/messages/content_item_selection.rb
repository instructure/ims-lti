require_relative '../concerns'

module Ims::Lti::Models::Messages
  # Class represeting a content item selection request.
  class ContentItemSelection
    include Ims::Lti::Models::Concerns::SerializedParameters
    attr_accessor :lti_message_type,
                  :lti_version,
                  :content_items,
                  :data,
                  :lti_msg,
                  :lti_log,
                  :lti_errormsg,
                  :lti_errorlog

    # Returns a new instance of ContentItemSelection.
    #
    # @param [Hash] attributes for message initialization.
    # @return [ContentItemSelection]
    def initialize(params = {})
      super
      self.lti_version = 'LTI-1p0'
      self.lti_message_type = 'ContentItemSelection'
    end
  end
end