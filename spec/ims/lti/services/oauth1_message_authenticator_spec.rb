require "spec_helper"

module IMS::LTI::Services
  describe OAuth1MessageAuthenticator do
    let(:launch_url) { 'http://www.example.com' }
    let(:params) { {user_id: '123', lti_message_type: IMS::LTI::Models::Messages::BasicLTILaunchRequest::MESSAGE_TYPE} }
    let(:oauth_consumer_key) { 'key' }
    let(:secret) { 'secret' }
    let(:signed_params) do
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
    let(:message) { MessageService.new(launch_url, signed_params).message }
    let(:ma) { OAuth1MessageAuthenticator.new(message, secret) }

    describe '#valid' do
      it "returns true for a valid signature" do
        expect(ma.valid_signature?).to eq true
      end

      # it 'handles string keys for params' do
      #   signed_params['oauth_signature'] = signed_params.delete(:oauth_signature)
      #   authenticator = MessageAuthenticator.new(launch_url, signed_params, secret)
      #   expect(authenticator.valid_signature?).to eq true
      # end
      #
      # it 'returns false for an invalid signature' do
      #   invalid_sig_params = signed_params.merge(oauth_signature: 'bad_sig')
      #   authenticator = MessageAuthenticator.new(launch_url, invalid_sig_params, secret)
      #   expect(authenticator.valid_signature?).to eq false
      # end

    end

    describe '#simple_oauth_header' do
      it 'simple_oauth_header used' do
        expect(ma.simple_oauth_header).to be_instance_of SimpleOAuth::Header
      end
    end

    describe '#base_string' do
      it 'returns the base string' do
        Timecop.freeze(Time.at(1491482659)) do
          expect(ma.base_string).to eq "POST&http%3A%2F%2Fwww.example.com%2F&lti_message_type%3Dbasic-lti-launch-request%26oauth_callback%3Dabout%253Ablank%26oauth_consumer_key%3Dkey%26oauth_nonce%3D#{ma.signed_params[:oauth_nonce]}%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D1491482659%26oauth_version%3D1.0%26user_id%3D123"
        end
      end
    end

    describe '#signed_params' do
      it 'returns signed params' do
        expect(ma.signed_params).to have_key(:oauth_signature)
      end

      it 'includes the oauth_callback' do
        expect(ma.signed_params).to include({oauth_callback: 'about:blank'})
      end
    end

  end
end