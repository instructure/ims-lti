require 'spec_helper'

module IMS::LTI::Models::Messages
  describe RequestMessage do

    it 'returns recommended param names' do
      expect(described_class.recommended_params).to eq [:user_id, :roles, :launch_presentation_document_target, :launch_presentation_width, :launch_presentation_height]
    end

    it 'returns optional param names' do
      expect(described_class.optional_params).to eq [:launch_presentation_locale, :launch_presentation_css_url]
    end

    it 'returns deprecated param names' do
      expect(described_class.deprecated_params).to eq []
    end


    describe 'parameters' do
      class CustomMessage < RequestMessage
        add_deprecated_params :foo
      end

      subject {CustomMessage.new(lti_version: '1', user_id: 3, launch_presentation_locale: 'en', foo: 'bar')}


      it 'returns all the supported params' do
        expect(subject.parameters).to eq({"lti_version"=>"1", "user_id"=>3, "launch_presentation_locale"=>"en", "foo"=>"bar"})
      end

      it 'returns the required params' do
        expect(subject.required_params).to eq({"lti_version"=>"1"})
      end

      it 'returns the recommended params' do
        expect(subject.recommended_params).to eq({"user_id"=>3})
      end

      it 'returns the deprecated params' do
        expect(subject.deprecated_params).to eq({"foo"=>"bar"})
      end
    end

  end
end