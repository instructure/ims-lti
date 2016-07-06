require "spec_helper"

module IMS::LTI::Services
  describe MessageAuthenticator do
    let(:launch_url) { 'http://www.example.com' }
    let(:params) { {user_id: '123', lti_message_type: IMS::LTI::Models::Messages::BasicLTILaunchRequest::MESSAGE_TYPE} }
    let(:oauth_consumer_key) { 'key' }
    let (:secret) { "secret"}
    let (:signed_params) do
      header = SimpleOAuth::Header.new(
        :post,
        launch_url,
        params,
        consumer_key: oauth_consumer_key,
        consumer_secret: secret,
        callback: 'about:blank'
      )
      header.signed_attributes.merge(params)
    end
    subject{ MessageAuthenticator.new(launch_url, signed_params, secret)}

    describe '#valid' do
      it "returns true for a valid signature" do
        authenticator = MessageAuthenticator.new(launch_url, signed_params, secret)
        expect(authenticator.valid_signature?).to eq true
      end

      it 'handles string keys for params' do
        signed_params['oauth_signature'] = signed_params.delete(:oauth_signature)
        authenticator = MessageAuthenticator.new(launch_url, signed_params, secret)
        expect(authenticator.valid_signature?).to eq true
      end

      it 'returns false for an invalid signature' do
        invalid_sig_params = signed_params.merge(oauth_signature: 'bad_sig')
        authenticator = MessageAuthenticator.new(launch_url, invalid_sig_params, secret)
        expect(authenticator.valid_signature?).to eq false
      end

    end

    describe '#message' do
      it 'returns a message' do
        expect(subject.message.lti_message_type).to eq IMS::LTI::Models::Messages::BasicLTILaunchRequest::MESSAGE_TYPE
      end

      it 'contains the launch url' do
        expect(subject.message.launch_url).to eq(launch_url)
      end

    end

    describe '#simple_oauth_header' do
      it 'simple_oauth_header used' do
        expect(subject.simple_oauth_header).to be_instance_of SimpleOAuth::Header
      end
    end

    describe "#base_string" do
      it 'returns the base string' do
        expect(subject.base_string).to start_with "POST&http%3A%2F%2Fwww.example.com%2F&lti_message_type%3Dbasic-lti-launch-request"
      end
    end

    describe "#signed_params" do
      it 'returns signed params' do
        expect(subject.signed_params).to have_key(:oauth_signature)
      end
    end

  end
end