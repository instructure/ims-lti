require 'active_model'

module Ims::Lti::Messages
  # Class represeting a content item selection request.
  class ContentItemSelectionRequest
    include ActiveModel::Model

    REQUIRED_PARAMETERS = %i[
      accept_media_types
      accept_presentation_document_targets
      content_item_return_url
      lti_message_type
      lti_version
    ].freeze

    validates_presence_of *REQUIRED_PARAMETERS
    attr_accessor *REQUIRED_PARAMETERS
    attr_accessor :accept_copy_advice,
                  :accept_multiple,
                  :accept_unsigned,
                  :context_id,
                  :context_label,
                  :context_title,
                  :context_type,
                  :data,
                  :lis_course_offering_sourcedid,
                  :lis_course_section_sourcedid,
                  :lis_person_contact_email_primary,
                  :lis_person_name_family,
                  :lis_person_name_full,
                  :lis_person_name_given,
                  :lis_person_sourcedid,
                  :role_scope_mentor,
                  :text,
                  :title,
                  :tool_consumer_info_product_family_code,
                  :tool_consumer_info_product_family_version,
                  :tool_consumer_info_version,
                  :tool_consumer_instance_contact_email,
                  :tool_consumer_instance_description,
                  :tool_consumer_instance_guid,
                  :tool_consumer_instance_name,
                  :tool_consumer_instance_url,
                  :user_image

    # Returns a new instance of ContentItemSelectionRequest.
    #
    # @param [Hash] attributes for message initialization.
    # @return [ContentItemSelectionRequest]
    def initialize(params = {})
      super
      self.lti_version = 'LTI-1p0'
      self.lti_message_type = 'ContentItemSelectionRequest'
    end
  end
end
