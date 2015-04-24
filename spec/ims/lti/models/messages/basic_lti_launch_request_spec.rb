require 'spec_helper'

module IMS::LTI::Models::Messages
  describe BasicLTILaunchRequest do

    it 'should have a default value for lti_message_type' do
      expect(subject.lti_message_type).to eq 'basic-lti-launch-request'
    end

    it "inherits parameters from $Message" do
      subject.user_id = '123'
      expect(subject.user_id).to eq '123'
      expect(subject.post_params.keys).to include('user_id')
    end

    it 'returns required param names' do
      expect(described_class.required_params).to eq [:lti_message_type, :lti_version, :resource_link_id]
    end

    it 'returns recommended param names' do
      expect(described_class.recommended_params).to eq [:user_id, :roles, :launch_presentation_document_target, :launch_presentation_width, :launch_presentation_height, :context_id, :launch_presentation_return_url, :tool_consumer_instance_guid]
    end

    it 'returns optional param names' do
      expect(described_class.optional_params).to eq [:launch_presentation_locale, :launch_presentation_css_url, :context_type, :role_scope_mentor, :user_image]
    end

    it 'returns deprecated param names' do
      expect(described_class.deprecated_params).to eq [:context_title, :context_label, :resource_link_title, :resource_link_description,
                                                       :lis_person_name_given, :lis_person_name_family, :lis_person_name_full,
                                                       :lis_person_contact_email_primary, :user_image, :lis_person_sourcedid,
                                                       :lis_course_offering_sourcedid, :lis_course_section_sourcedid,
                                                       :tool_consumer_info_product_family_code, :tool_consumer_info_product_family_version,
                                                       :tool_consumer_instance_name, :tool_consumer_instance_description, :tool_consumer_instance_url,
                                                       :tool_consumer_instance_contact_email, :tool_consumer_info_version]
    end


  end
end