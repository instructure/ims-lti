require 'spec_helper'

module IMS::LTI::Models::Messages
  describe ToolProxyReregistrationRequest do

    it 'returns required param names' do
      expect(described_class.required_params).to match_array %i(lti_message_type tc_profile_url launch_presentation_return_url lti_version)
    end

    it 'returns recommended param names' do
      expect(described_class.recommended_params).to match_array %i(launch_presentation_document_target launch_presentation_height launch_presentation_width user_id roles)
    end

    it 'returns optional param names' do
      expect(described_class.optional_params).to match_array %i(launch_presentation_css_url launch_presentation_locale)
    end

    it 'should have a default value for lti_message_type' do
      expect(subject.lti_message_type).to eq 'ToolProxyReregistrationRequest'
    end


  end
end