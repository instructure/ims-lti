require 'spec_helper'

module IMS::LTI::Models::Messages
  describe Message do
    describe 'parameters' do
      it "returns params for the message" do
        subject.lti_message_type = 'message-type'
        subject.user_id = '123456'

        params = subject.post_params
        expect(params['lti_message_type']).to eq('message-type')
        expect(params['user_id']).to eq('123456')
      end

      it 'returns custom params for the message' do
        subject.custom_name = 'my_custom_name'

        params = subject.post_params
        expect(params['custom_name']).to eq('my_custom_name')
      end

      it 'returns ext params for the message' do
        subject.ext_name = 'my_ext_name'

        params = subject.post_params
        expect(params['ext_name']).to eq('my_ext_name')
      end

      it 'sets a ext param' do
        subject.ext_name = 'my_ext_name'
        expect(subject.ext_name).to eq 'my_ext_name'
      end

      it 'sets an custom param' do
        subject.custom_name = 'my_custom_name'
        expect(subject.custom_name).to eq 'my_custom_name'
      end

      it 'returns all the custom params' do
        subject.custom_name = 'my_custom_name'
        subject.custom_number = '3'
        subject.user_id = 2
        params = subject.post_params
        expect(params['custom_name']).to eq 'my_custom_name'
        expect(params['custom_number']).to eq '3'
      end

      it 'returns all the ext params' do
        subject.ext_name = 'my_ext_name'
        subject.ext_number = '42'
        subject.user_id = 2
        params = subject.post_params
        expect(params['ext_name']).to eq 'my_ext_name'
        expect(params['ext_number']).to eq '42'
      end

      it 'returns required param names' do
        expect(described_class.required_params).to eq [:lti_message_type, :lti_version]
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

      it 'returns unknown params' do
        message = described_class.new(foo: 'bar')
        expect(message.unknown_params).to eq({'foo' => 'bar'})
      end


    end
    it 'sets configured attributes' do
      message = described_class.new(lti_message_type: 'message-type')
      expect(message.lti_message_type).to eq 'message-type'
    end

    it 'sets custom attributes' do
      message = described_class.new(custom_attribute: 'custom_value')
      expect(message.custom_attribute).to eq 'custom_value'
    end

    it 'sets extension attributes' do
      message = described_class.new(ext_attribute: 'extension_value')
      expect(message.ext_attribute).to eq 'extension_value'
    end

    describe '#add_custom_params' do

      it 'prepends "custom_" to the param' do
        subject.add_custom_params('foo' => 'bar')
        params = subject.instance_variable_get('@custom_params')
        expect(params.keys.size).to eq 1
        expect(params.keys.first).to eq 'custom_foo'
      end

      it 'handles symbols' do
        subject.add_custom_params(foo: 'bar')
        params = subject.instance_variable_get('@custom_params')
        expect(params.keys.first).to eq 'custom_foo'
      end

    end

    describe '#get_custom_params' do
      it 'removes "custom_" to the parameter' do
        subject.add_custom_params('custom_foo' => 'bar')
        params = subject.get_custom_params
        expect(params.keys.size).to eq 1
        expect(params.keys.first).to eq 'foo'
      end
    end

    context 'OAuth' do
      describe "#signed_post_params" do
        it "creates a hash with the oauth signature" do
          subject.user_id = 'user_id'
          subject.launch_url = 'http://www.example.com'
          subject.oauth_consumer_key = 'key'

          params = subject.signed_post_params('secret')

          expect(params[:oauth_consumer_key]).to eq "key"
          expect(params[:oauth_signature_method]).to eq "HMAC-SHA1"
          expect(params[:oauth_version]).to eq "1.0"
          expect(params['user_id']).to eq "user_id"
          expect(params.key?(:oauth_signature)).to eq true
          expect(params.key?(:oauth_timestamp)).to eq true
          expect(params.key?(:oauth_nonce)).to eq true
        end
      end

      describe "#valid_signature?" do
        it "returns true for a valid signature" do
          subject.launch_url = 'http://www.example.com'
          params = subject.signed_post_params('secret')
          message = described_class.new(params)
          message.launch_url = 'http://www.example.com'
          expect(message.valid_signature?('secret')).to eq true
        end

        it "returns false for an invalid signature" do
          message = IMS::LTI::Models::Messages::Message.new
          subject.launch_url = 'http://www.example.com'
          params = subject.signed_post_params('secret')

          message = described_class.new(params)
          message.launch_url = 'http://www.example.com'
          expect(message.valid_signature?('bad_secret')).to eq false
        end
      end
    end

  end
end