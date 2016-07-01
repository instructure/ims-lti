require 'spec_helper'

module IMS::LTI::Models::Messages
  describe Message do
    describe 'parameters' do
      it "returns params for the message" do
        subject.lti_message_type = 'message-type'

        params = subject.post_params
        expect(params['lti_message_type']).to eq('message-type')
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
        params = subject.post_params
        expect(params['custom_name']).to eq 'my_custom_name'
        expect(params['custom_number']).to eq '3'
      end

      it 'returns all the ext params' do
        subject.ext_name = 'my_ext_name'
        subject.ext_number = '42'
        params = subject.post_params
        expect(params['ext_name']).to eq 'my_ext_name'
        expect(params['ext_number']).to eq '42'
      end

      it 'returns required param names' do
        expect(described_class.required_params).to eq [:lti_message_type, :lti_version]
      end


      it 'returns unknown params' do
        message = described_class.new(foo: 'bar')
        expect(message.unknown_params).to eq({'foo' => 'bar'})
      end

      describe 'parameters' do
        class CustomMesage < Message
          add_deprecated_params :foo
        end

        subject {CustomMesage.new(lti_version: '1', foo: 'bar')}


        it 'returns all the supported params' do
          expect(subject.parameters).to eq({"lti_version"=>"1", "foo"=>"bar"})
        end

        it 'returns the required params' do
          expect(subject.required_params).to eq({"lti_version"=>"1"})
        end

      end

    end

    describe ".descendants" do

      it 'returns multiple levels of descendents' do
        expect(described_class.descendants).to include(BasicLTILaunchRequest, ContentItemSelection)
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
          subject.custom_user_id = 'user_id'
          subject.launch_url = 'http://www.example.com'
          subject.oauth_consumer_key = 'key'

          params = subject.signed_post_params('secret')

          expect(params[:oauth_consumer_key]).to eq "key"
          expect(params[:oauth_signature_method]).to eq "HMAC-SHA1"
          expect(params[:oauth_version]).to eq "1.0"
          expect(params['custom_user_id']).to eq "user_id"
          expect(params.key?(:oauth_signature)).to eq true
          expect(params.key?(:oauth_timestamp)).to eq true
          expect(params.key?(:oauth_nonce)).to eq true
        end
      end

      describe "#valid_signature?" do
        it "returns true for a valid signature" do
          subject.launch_url = 'http://www.example.com'
          secret = 'secret'
          params = subject.signed_post_params(secret)
          expect(IMS::LTI::Models::Messages::Message.valid_signature?(subject.launch_url, params, secret)).to eq true
        end

        it "returns false for an invalid signature" do
          subject.launch_url = 'http://www.example.com'
          params = subject.signed_post_params('secret')
          expect(IMS::LTI::Models::Messages::Message.valid_signature?('http://www.example.com', params, 'bad_secret')).to eq false
        end
      end
    end

    describe "#generate" do

      it 'generates a BasicLTILaunchRequest message' do
        message = described_class.generate({'lti_message_type' => BasicLTILaunchRequest::MESSAGE_TYPE })
        expect(message).to be_a BasicLTILaunchRequest
      end

      it 'generates a RegistrationRequest message' do
        message = described_class.generate({'lti_message_type' => RegistrationRequest::MESSAGE_TYPE })
        expect(message).to be_a RegistrationRequest
      end

      it 'generates a ContentItemSelectionRequest message' do
        message = described_class.generate({'lti_message_type' => ContentItemSelectionRequest::MESSAGE_TYPE })
        expect(message).to be_a ContentItemSelectionRequest
      end

      it 'generates a ContentItemSelection message' do
        message = described_class.generate({'lti_message_type' => ContentItemSelection::MESSAGE_TYPE })
        expect(message).to be_a ContentItemSelection
      end

      it 'generates a ToolProxyReregistration message' do
        message = described_class.generate({'lti_message_type' => ToolProxyReregistrationRequest::MESSAGE_TYPE})
        expect(message).to be_a ToolProxyReregistrationRequest
      end


    end

  end
end