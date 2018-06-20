module Ims::Lti::Models::Messages
  RSpec.describe BasicLtiLaunchRequest do
    let(:resource_link_id) { '12345' }
    let(:message) { BasicLtiLaunchRequest.new }

    describe '#initialize' do
      it 'allows initializing with attributes' do
        new_message = BasicLtiLaunchRequest.new(resource_link_id: resource_link_id)
        expect(new_message.resource_link_id).to eq resource_link_id
      end

      it 'defaults "lti_message_type" to "basic-lti-launch-request"' do
        expect(message.lti_message_type).to eq 'basic-lti-launch-request'
      end

      it 'defaults "lti_version" to "LTI-1p0"' do
        expect(message.lti_version).to eq 'LTI-1p0'
      end
    end

    describe '#parameters' do
      it 'contains all available message parameters' do
        expect(message.parameters.keys).to match_array [
          :context_id,
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
          :lti_message_type,
          :lti_version,
          :resource_link_description,
          :resource_link_id,
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
        ]
      end
    end
  end
end