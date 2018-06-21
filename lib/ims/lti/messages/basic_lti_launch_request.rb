require 'active_model'

module Ims::Lti::Messages
  # Class represeting a basic lti launch request.
  class BasicLtiLaunchRequest
    include ActiveModel::Model

    REQUIRED_PARAMETERS = %i[
      resource_link_id
      lti_version
      lti_message_type
    ].freeze

    validates_presence_of *REQUIRED_PARAMETERS
    attr_accessor *REQUIRED_PARAMETERS
    attr_accessor :context_id,
                  :context_label,
                  :context_title,
                  :context_type,
                  :launch_presentation_return_url,
                  :lis_course_offering_sourcedid,
                  :lis_course_section_sourcedid,
                  :lis_outcome_service_url,
                  :lis_person_contact_email_primary,
                  :lis_person_name_family,
                  :lis_person_name_full,
                  :lis_person_name_given,
                  :lis_person_sourced_id,
                  :lis_person_sourcedid,
                  :lis_result_sourcedid,
                  :resource_link_description,
                  :resource_link_title,
                  :role_scope_mentor,
                  :tool_consumer_info_product_family_code,
                  :tool_consumer_info_product_family_version,
                  :tool_consumer_info_version,
                  :tool_consumer_instance_contact_email,
                  :tool_consumer_instance_description,
                  :tool_consumer_instance_guid,
                  :tool_consumer_instance_name,
                  :tool_consumer_instance_url,
                  :user_image

    # Returns a new instance of BasicLtiLaunchRequest.
    #
    # @param [Hash] attributes for message initialization.
    # @return [BasicLtiLaunchRequest]
    def initialize(params = {})
      super
      self.lti_version = 'LTI-1p0'
      self.lti_message_type = 'basic-lti-launch-request'
    end
  end
end
