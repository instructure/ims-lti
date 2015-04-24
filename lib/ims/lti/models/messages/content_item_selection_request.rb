module IMS::LTI::Models::Messages
  class ContentItemSelectionRequest < RequestMessage

    add_required_params :accept_media_types, :accept_presentation_document_targets, :content_item_return_url
    add_recommended_params :context_id,  :tool_consumer_instance_guid
    add_optional_params :context_type, :role_scope_mentor, :user_image, :accept_unsigned, :accept_multiple,
                        :accept_copy_advice, :text, :title, :data
    add_deprecated_params :context_title, :context_label,
                          :lis_person_name_given, :lis_person_name_family, :lis_person_name_full,
                          :lis_person_contact_email_primary, :user_image, :lis_person_sourcedid,
                          :lis_course_offering_sourcedid, :lis_course_section_sourcedid,
                          :tool_consumer_info_product_family_code, :tool_consumer_info_product_family_version,
                          :tool_consumer_instance_name, :tool_consumer_instance_description,
                          :tool_consumer_instance_url, :tool_consumer_instance_contact_email,
                          :tool_consumer_info_version

    MESSAGE_TYPE = 'ContentItemSelectionRequest'

    def initialize(attrs = {})
      super(attrs)
      self.lti_message_type = MESSAGE_TYPE
    end


  end
end