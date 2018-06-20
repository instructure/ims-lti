module Ims::Lti::Models::Messages
  RSpec.describe ContentItemSelectionRequest do
    let(:content_item_return_url) { 'https://www.test.com/return' }
    let(:message) { ContentItemSelectionRequest.new }

    describe '#initialize' do
      it 'allows initializing with attributes' do
        new_message = ContentItemSelectionRequest.new(content_item_return_url: content_item_return_url)
        expect(new_message.content_item_return_url).to eq content_item_return_url
      end

      it 'defaults "lti_message_type" to "ContentItemSelectionRequest"' do
        expect(message.lti_message_type).to eq 'ContentItemSelectionRequest'
      end

      it 'defaults "lti_version" to "LTI-1p0"' do
        expect(message.lti_version).to eq 'LTI-1p0'
      end
    end

    describe '#parameters' do
      it 'contains all available message parameters' do
        expect(message.parameters.keys).to match_array [
          :accept_copy_advice,
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
        ]
      end
    end
  end
end