require 'spec_helper'

module IMS::LTI::Models::Messages
  describe RegistrationRequest do

    it 'sets the message type' do
      expect(subject.lti_message_type).to eq 'ToolProxyRegistrationRequest'
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