require 'spec_helper'

module IMS::LTI::Models::Messages
  describe RegistrationRequest do

    it "inherits parameters from $Message" do
      subject.user_id = '123'
      expect(subject.user_id).to eq '123'
      expect(subject.post_params.keys).to include('user_id')
    end

    it 'sets the message type' do
      expect(subject.lti_message_type).to eq 'ToolProxyRegistrationRequest'
    end

    it 'returns required param names' do
      expect(described_class.required_params).to eq [:lti_message_type, :lti_version, :reg_key, :reg_password, :tc_profile_url, :launch_presentation_return_url]
    end

    it 'returns recommended param names' do
      expect(described_class.recommended_params).to eq [:user_id, :roles, :launch_presentation_document_target, :launch_presentation_width, :launch_presentation_height]
    end

    it 'returns optional param names' do
      expect(described_class.optional_params).to eq [:launch_presentation_locale, :launch_presentation_css_url]
    end

    it 'returns deprecated param names' do
      expect(described_class.deprecated_params).to eq []
    end

    describe "#generate_key_and_password" do
      before(:each) do
        allow(SecureRandom).to receive(:uuid).and_return('random_uuid')
      end

      it 'generates and sets the key' do
        subject.generate_key_and_password
        expect(subject.reg_key).to eq 'random_uuid'
      end

      it 'generates and sets the password' do
        subject.generate_key_and_password
        expect(subject.reg_password).to eq 'random_uuid'
      end

      it 'returns the key and secret' do
        expect(subject.generate_key_and_password).to eq 2.times.map{ 'random_uuid' }
      end
    end


  end
end