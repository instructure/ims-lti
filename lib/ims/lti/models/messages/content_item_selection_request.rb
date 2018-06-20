require 'active_model'
require_relative '../concerns'

module Ims::Lti::Models::Messages
  # Class represeting a content item selection request.
  class ContentItemSelectionRequest
    include Ims::Lti::Models::Concerns::SerializedParameters
    attr_accessor :accept_copy_advice,
                  :accept_media_types,
                  :accept_multiple,
                  :accept_presentation_document_targets,
                  :accept_unsigned,
                  :content_item_return_url,
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
                  :lti_message_type,
                  :lti_version,
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