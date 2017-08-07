require 'spec_helper'

module IMS::LTI::Models::Messages
  describe Message do

    subject(:message) {Message.new}

    describe 'parameters' do
      it "returns params for the message" do
        message.lti_message_type = 'message-type'

        params = message.post_params
        expect(params['lti_message_type']).to eq('message-type')
      end

      it 'returns custom params for the message' do
        message.custom_name = 'my_custom_name'

        params = message.post_params
        expect(params['custom_name']).to eq('my_custom_name')
      end

      it 'returns ext params for the message' do
        message.ext_name = 'my_ext_name'

        params = message.post_params
        expect(params['ext_name']).to eq('my_ext_name')
      end

      it 'sets a ext param' do
        message.ext_name = 'my_ext_name'
        expect(message.ext_name).to eq 'my_ext_name'
      end

      it 'sets an custom param' do
        message.custom_name = 'my_custom_name'
        expect(message.custom_name).to eq 'my_custom_name'
      end

      it 'returns all the custom params' do
        message.custom_name = 'my_custom_name'
        message.custom_number = '3'
        params = message.post_params
        expect(params['custom_name']).to eq 'my_custom_name'
        expect(params['custom_number']).to eq '3'
      end

      it 'returns all the ext params' do
        message.ext_name = 'my_ext_name'
        message.ext_number = '42'
        params = message.post_params
        expect(params['ext_name']).to eq 'my_ext_name'
        expect(params['ext_number']).to eq '42'
      end

      it 'returns required param names' do
        expect(described_class.required_params).to eq [:lti_message_type, :lti_version]
      end


      it 'returns unknown params' do
        message = described_class.new(foo: 'bar')
        expect(message.unknown_params).to eq({ 'foo' => 'bar' })
      end

      describe 'parameters' do
        class CustomMesage < Message
          add_deprecated_params :foo
        end

        subject(:message) {CustomMesage.new(lti_version: '1', foo: 'bar')}


        it 'returns all the supported params' do
          expect(message.parameters).to eq({ "lti_version" => "1", "foo" => "bar" })
        end

        it 'returns the required params' do
          expect(message.required_params).to eq({ "lti_version" => "1" })
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
        message.add_custom_params('foo' => 'bar')
        params = message.instance_variable_get('@custom_params')
        expect(params.keys.size).to eq 1
        expect(params.keys.first).to eq 'custom_foo'
      end

      it 'handles symbols' do
        message.add_custom_params(foo: 'bar')
        params = message.instance_variable_get('@custom_params')
        expect(params.keys.first).to eq 'custom_foo'
      end

    end

    describe '#get_custom_params' do
      it 'removes "custom_" to the parameter' do
        message.add_custom_params('custom_foo' => 'bar')
        params = message.get_custom_params
        expect(params.keys.size).to eq 1
        expect(params.keys.first).to eq 'foo'
      end
    end

    describe '#get_ext_params' do
      it 'removes "ext_" to the parameter' do
        message.ext_name = "name"
        params = message.get_ext_params
        expect(params.keys.size).to eq 1
        expect(params.keys.first).to eq 'name'
      end
    end

    context 'OAuth' do
      describe "#signed_post_params" do
        it "creates a hash with the oauth signature" do
          message.custom_user_id = 'user_id'
          message.launch_url = 'http://www.example.com'
          message.oauth_consumer_key = 'key'

          params = message.signed_post_params('secret')

          expect(params[:oauth_consumer_key]).to eq "key"
          expect(params[:oauth_signature_method]).to eq "HMAC-SHA1"
          expect(params[:oauth_version]).to eq "1.0"
          expect(params['custom_user_id']).to eq "user_id"
          expect(params.key?(:oauth_signature)).to eq true
          expect(params.key?(:oauth_timestamp)).to eq true
          expect(params.key?(:oauth_nonce)).to eq true
        end

        it "includes oauth_params" do
          message.custom_user_id = 'user_id'
          message.launch_url = 'http://www.example.com'
          message.oauth_consumer_key = 'key'
          message.oauth_callback = 'about:blank'

          params = message.signed_post_params('secret')

          expect(params[:oauth_callback]).to eq 'about:blank'
        end

      end
    end

    describe "#generate" do

      it 'generates a BasicLTILaunchRequest message' do
        message = described_class.generate({ 'lti_message_type' => BasicLTILaunchRequest::MESSAGE_TYPE })
        expect(message).to be_a BasicLTILaunchRequest
      end

      it 'generates a RegistrationRequest message' do
        message = described_class.generate({ 'lti_message_type' => RegistrationRequest::MESSAGE_TYPE })
        expect(message).to be_a RegistrationRequest
      end

      it 'generates a ContentItemSelectionRequest message' do
        message = described_class.generate({ 'lti_message_type' => ContentItemSelectionRequest::MESSAGE_TYPE })
        expect(message).to be_a ContentItemSelectionRequest
      end

      it 'generates a ContentItemSelection message' do
        message = described_class.generate({ 'lti_message_type' => ContentItemSelection::MESSAGE_TYPE })
        expect(message).to be_a ContentItemSelection
      end

      it 'generates a ToolProxyReregistration message' do
        message = described_class.generate({ 'lti_message_type' => ToolProxyReregistrationRequest::MESSAGE_TYPE })
        expect(message).to be_a ToolProxyReregistrationRequest
      end

      context "jwt" do
        let(:originating_domain) {'example.com'}
        let(:private_key) {'shhhh'}
        let(:consumer_key) {'42'}
        let(:launch_url) {'http://example.com/launch'}

        let(:orig_message)  do
          m = BasicLTILaunchRequest.new(consumer_key: consumer_key)
          m.launch_url = launch_url
          m
        end
        let(:jwt_params) {orig_message.jwt_params(private_key: private_key, originating_domain: originating_domain)}

        it 'generates the correct message' do
          message = Message.generate(jwt_params)
          expect(message).to be_a BasicLTILaunchRequest
        end

        it 'sets ims parameters' do
          context_id = '123'
          orig_message.context_id = context_id
          message = Message.generate(jwt_params)
          expect(message.context_id).to eq context_id
        end

        it 'sets custom parameters' do
          custom_roles = %w(Student Instructor)
          orig_message.custom_roles = custom_roles
          message = Message.generate(jwt_params)
          expect(message.custom_roles).to eq custom_roles
        end

        it 'sets ext parameters' do
          ext_roles = %w(Student Instructor)
          orig_message.ext_roles = ext_roles
          message = Message.generate(jwt_params)
          expect(message.ext_roles).to eq ext_roles
        end

        it 'sets the consumer_key' do
          message = Message.generate(jwt_params)
          expect(message.consumer_key).to eq consumer_key
        end

        it 'stores the original jwt' do
          message = Message.generate(jwt_params)
          expect(message.jwt).to eq jwt_params['jwt']
        end

      end
    end

    context("jwt") do
      let(:private_key) {'secret'}
      let(:launch_url) {'http://www.example.com'}
      let(:originating_domain) {'instructure.com'}
      let(:consumer_key) {'key'}
      subject(:message) {Message.new(consumer_key: consumer_key)}

      describe "#jwt_params" do
        it "returns a hash with a jwt assigned to the jwt key" do
          params = message.jwt_params(private_key: private_key, originating_domain: originating_domain)
          json = JSON::JWT.decode(params['jwt'], private_key)
          expect(json[:iss]).to eq originating_domain
        end
      end

      describe "#to_jwt" do
        it "sets the 'iss' to the originating domain" do
          jwt = message.to_jwt(private_key: private_key, originating_domain: originating_domain)
          json = JSON::JWT.decode(jwt, private_key)
          expect(json[:iss]).to eq originating_domain
        end

        it "sets the 'sub' to the consumer_key" do
          jwt = message.to_jwt(private_key: private_key, originating_domain: originating_domain)
          json = JSON::JWT.decode(jwt, private_key)
          expect(json[:sub]).to eq consumer_key
        end

        it "sets the 'aud' to the launch_url" do
          message.launch_url = launch_url
          jwt = message.to_jwt(private_key: private_key, originating_domain: originating_domain)
          json = JSON::JWT.decode(jwt, private_key)
          expect(json[:aud]).to eq launch_url
        end

        it "sets the iat to the current time" do
          Timecop.freeze do
            jwt = message.to_jwt(private_key: private_key, originating_domain: originating_domain)
            json = JSON::JWT.decode(jwt, private_key)
            expect(json[:iat]).to eq Time.now.to_i
          end
        end

        it "sets the exp to 5 minutes in the future" do
          Timecop.freeze do
            jwt = message.to_jwt(private_key: private_key, originating_domain: originating_domain)
            json = JSON::JWT.decode(jwt, private_key)
            expect(json[:exp]).to eq (Time.now + 60 * 5).to_i
          end
        end

        it "sets a 'jti'" do
          jwt = message.to_jwt(private_key: private_key, originating_domain: originating_domain)
          json = JSON::JWT.decode(jwt, private_key)
          expect(json[:jti]).to_not be_nil
        end

        it "creates a new jti each time" do
          jwt1 = message.to_jwt(private_key: private_key, originating_domain: originating_domain)
          jwt2 = message.to_jwt(private_key: private_key, originating_domain: originating_domain)
          json1 = JSON::JWT.decode(jwt1, private_key)
          json2 = JSON::JWT.decode(jwt2, private_key)
          expect(json1[:jti]).to_not eq json2[:jti]
        end

        context "ims claims" do
          let(:user_id) {"user_id"}
          it 'sets ims claims' do
            roles = ["Instructor", "Student"]
            message = Message.new(roles: roles)
            message.custom_user_id = user_id
            message.ext_life_universe_everything = 42
            jwt = message.to_jwt(private_key: private_key, originating_domain: originating_domain)
            json = JSON::JWT.decode(jwt, private_key)[:"org.imsglobal.lti.message"]
            expect(json).to eq (
                                 {
                                   "roles" => roles,
                                   "custom" => {
                                     "user_id" => message.custom_user_id
                                   },
                                   "ext" => {
                                     "life_universe_everything" => message.ext_life_universe_everything
                                   }
                                 }
                               )
          end
        end
      end

    end


  end
end
