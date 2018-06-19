module Ims::Lti::Models::Messages
  RSpec.describe BasicLtiLaunchRequest do
    let(:empty_message) { BasicLtiLaunchRequest.new }
    let(:valid_message) { BasicLtiLaunchRequest.new(resource_link_id: '1234') }

    describe '#parameters' do
      it 'returns a hash of all parameters' do
        expect(empty_message.parameters.keys).to match_array %i[
          lti_message_type resource_link_id lti_version resource_link_title user_id roles
          context_id context_title context_label launch_presentation_document_target
          launch_presentation_width launch_presentation_height launch_presentation_return_url
          tool_consumer_info_product_family_code tool_consumer_info_version tool_consumer_instance_name
          tool_consumer_instance_contact_email tool_consumer_instance_guid resource_link_description
          user_image context_type tool_consumer_instance_description tool_consumer_instance_url
          role_scope_mentor lis_outcome_service_url lis_person_sourced_id lis_result_sourcedid
          lis_person_name_given lis_person_name_family lis_person_name_full
          lis_person_contact_email_primary lis_person_sourcedid lis_course_offering_sourcedid
          lis_course_section_sourcedid tool_consumer_info_product_family_version custom extensions
        ]
      end
    end

    describe "#required_parameters" do
      it 'returns the required parameters' do
        expect(BasicLtiLaunchRequest.required_parameters).to match_array %i[
          lti_message_type resource_link_id lti_version
        ]
      end
    end

    describe "#recommended_parameters" do
      it 'returns the required parameters' do
        expect(BasicLtiLaunchRequest.recommended_parameters).to match_array %i[
          resource_link_title user_id roles context_id context_title
          context_label launch_presentation_document_target
          launch_presentation_width launch_presentation_height
          launch_presentation_return_url tool_consumer_info_product_family_code
          tool_consumer_info_version tool_consumer_instance_name
          tool_consumer_instance_contact_email tool_consumer_instance_guid
        ]
      end
    end

    describe "#optional_parameters" do
      it 'returns the required parameters' do
        expect(BasicLtiLaunchRequest.optional_parameters).to match_array %i[
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

    describe "validations" do
      it 'is valid if all required parameters are present' do
        expect(valid_message.valid?).to eq true
      end

      it 'is invalid if required paremters are missing' do
        valid_message.resource_link_id = nil
        expect(valid_message.valid?).to eq false
      end
    end
  end
end
