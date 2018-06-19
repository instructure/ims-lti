module Ims::Lti::Models::Messages
  # Class representding an lti basic launch request.
  #
  # @attr [String] lti_message_type Required. Defaults to "basic-lti-launch-request"
  # @attr [String] lti_version Required. Defaults to "LTI-1p0"
  # @attr [String] resource_link_id Required.
  # @attr [String] resource_link_title
  # @attr [String] user_id
  # @attr [Array] roles
  # @attr [String] context_id
  # @attr [String] context_title
  # @attr [String] context_label
  # @attr [String] launch_presentation_document_target
  # @attr [String] launch_presentation_width
  # @attr [String] launch_presentation_height
  # @attr [String] launch_presentation_return_url
  # @attr [String] tool_consumer_info_product_family_code
  # @attr [String] tool_consumer_info_version
  # @attr [String] tool_consumer_instance_name
  # @attr [String] tool_consumer_instance_contact_email
  # @attr [String] tool_consumer_instance_guid
  # @attr [String] resource_link_description
  # @attr [String] user_image
  # @attr [String] context_type
  # @attr [String] tool_consumer_instance_description
  # @attr [String] tool_consumer_instance_url
  # @attr [String] role_scope_mentor
  # @attr [String] lis_outcome_service_url
  # @attr [String] lis_person_sourced_id
  # @attr [String] lis_result_sourcedid
  # @attr [String] lis_person_name_given
  # @attr [String] lis_person_name_family
  # @attr [String] lis_person_name_full
  # @attr [String] lis_person_contact_email_primary
  # @attr [String] lis_person_sourcedid
  # @attr [String] lis_course_offering_sourcedid
  # @attr [String] lis_course_section_sourcedid
  # @attr [String] tool_consumer_info_product_family_version
  class BasicLtiLaunchRequest < Message
    # Returns a new instance of BasicLtiLaunchRequest.
    #
    # @param params [Hash] A hash of attributes used for object initialization.
    # @return [BasicLtiLaunchRequest] the new instance.
    def initialize(params = {})
      super
      self.lti_message_type = 'basic-lti-launch-request'
      self.lti_version = 'LTI-1p0'
    end

    class << self
      # Returns all required parameters as an array of symbols.
      #
      # @return [Array] all required parameters
      def required_parameters
        %i[lti_message_type resource_link_id lti_version]
      end

      # Returns all recommended parameters as an array of symbols.
      #
      # @return [Array] all recommended parameters
      def recommended_parameters
        %i[
          resource_link_title user_id roles context_id context_title
          context_label launch_presentation_document_target
          launch_presentation_width launch_presentation_height
          launch_presentation_return_url tool_consumer_info_product_family_code
          tool_consumer_info_version tool_consumer_instance_name
          tool_consumer_instance_contact_email tool_consumer_instance_guid
        ]
      end

      # Returns all optional parameters as an array of symbols.
      #
      # @return [Array] all optional parameters
      def optional_parameters
        %i[
          resource_link_description user_image context_type
          tool_consumer_instance_description tool_consumer_instance_url
          role_scope_mentor lis_outcome_service_url lis_person_sourced_id
          lis_result_sourcedid lis_person_name_given lis_person_name_family
          lis_person_name_full lis_person_contact_email_primary
          lis_person_sourcedid lis_course_offering_sourcedid
          lis_course_section_sourcedid tool_consumer_info_product_family_version
        ]
      end
    end
  end
end
