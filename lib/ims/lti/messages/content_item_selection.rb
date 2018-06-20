require 'active_model'

module Ims::Lti::Messages
  # Class represeting a content item selection request.
  class ContentItemSelection
    include ActiveModel::Model

    REQUIRED_PARAMETERS = %i[lti_message_type lti_version].freeze

    validates_presence_of *REQUIRED_PARAMETERS
    attr_accessor *REQUIRED_PARAMETERS
    attr_accessor :content_items,
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
