module IMS::LTI::Models::Messages
  class BasicLTILaunchRequest < IMS::LTI::Models::Messages::Message

    required_params :resource_link_id
    recommended_params :context_id, :launch_presentation_return_url, :tool_consumer_instance_guid
    optional_params :context_type, :role_scope_mentor, :user_image
    deprecated_params :context_title, :context_label, :resource_link_title, :resource_link_description,
                      :lis_person_name_given, :lis_person_name_family, :lis_person_name_full,
                      :lis_person_contact_email_primary, :user_image, :lis_person_sourcedid,
                      :lis_course_offering_sourcedid, :lis_course_section_sourcedid,
                      :tool_consumer_info_product_family_code, :tool_consumer_info_product_family_version,
                      :tool_consumer_instance_name, :tool_consumer_instance_description, :tool_consumer_instance_url,
                      :tool_consumer_instance_contact_email

    MESSAGE_TYPE = 'basic-lti-launch-request'

    def initialize(attrs = {})
      super(attrs)
      self.lti_message_type = MESSAGE_TYPE
    end

  end
end