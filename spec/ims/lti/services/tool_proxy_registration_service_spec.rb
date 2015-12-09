require 'spec_helper'

module IMS::LTI::Services
  describe ToolProxyRegistrationService do
    let(:reg_key) { 'reg_key' }
    let(:reg_password) { 'reg_password' }
    let(:registration_request) { IMS::LTI::Models::Messages::RegistrationRequest.new(
        tc_profile_url: '/profile/url', reg_key: reg_key, reg_password: reg_password
    ) }
    let(:faraday) { double }
    subject { ToolProxyRegistrationService.new(registration_request) }

    before(:each) do
      allow(Faraday).to receive(:new) { faraday }
    end

    describe '#tool_consumer_profile' do
      it 'gets the ToolConsumerProfile' do
        expect(faraday).to receive(:get).with('/profile/url') { double(body: '{"id": "profile_id"}') }

        tcp = subject.tool_consumer_profile

        expect(tcp).to be_a IMS::LTI::Models::ToolConsumerProfile
        expect(tcp.id).to eq 'profile_id'
      end
    end

    describe '#service_profiles' do
      it 'maps the ToolConsumer.services_offered to rest service profiles' do
        service_offered = []
        3.times { service_offered << IMS::LTI::Models::RestService.new }
        tcp = IMS::LTI::Models::ToolConsumerProfile.new(service_offered: service_offered)
        allow(subject).to receive(:tool_consumer_profile) { tcp }

        service_profiles = subject.service_profiles
        expect(service_profiles.size).to eq 3
        service_profiles.each { |sp| expect(sp).to be_a IMS::LTI::Models::RestServiceProfile }
      end
    end

    describe '#register_tool_proxy' do
      let(:response) { double }
      before(:each) do
        service_offered = IMS::LTI::Models::RestService.new(
            format: 'application/vnd.ims.lti.v2.toolproxy+json',
            action: 'POST'
        )
        tcp = IMS::LTI::Models::ToolConsumerProfile.new(service_offered: service_offered)
        allow(subject).to receive(:tool_consumer_profile) { tcp }
        allow(faraday).to receive(:post) { response }
      end

      it 'merges the tool proxy with the tool proxy response' do
        allow(response).to receive(:status) { 201 }
        allow(response).to receive(:body) { '{"tool_proxy_guid": "another_guid"}' }
        tool_proxy = IMS::LTI::Models::ToolProxy.new(id: 'some/json-ld/id', tool_proxy_guid: 'a_guid')

        new_tp = subject.register_tool_proxy(tool_proxy)

        expect(tool_proxy.tool_proxy_guid).to eq 'a_guid'
        expect(new_tp.id).to eq 'some/json-ld/id'
        expect(new_tp.tool_proxy_guid).to eq 'another_guid'
      end

      it "throws an error if the response isn't 201" do
        allow(response).to receive(:status) { 400 }
        allow(response).to receive(:body) { '{"error": "failed"}' }
        tool_proxy = IMS::LTI::Models::ToolProxy.new(id: 'some/json-ld/id', tool_proxy_guid: 'a_guid')
        expect { subject.register_tool_proxy(tool_proxy) }.to raise_error(IMS::LTI::Errors::ToolProxyRegistrationError)
      end

      it 'sets the code and body on the exception if the response is not 201' do
        allow(response).to receive(:status) { 400 }
        allow(response).to receive(:body) { '{"error": "failed"}' }
        tool_proxy = IMS::LTI::Models::ToolProxy.new(id: 'some/json-ld/id', tool_proxy_guid: 'a_guid')
        begin
          subject.register_tool_proxy(tool_proxy)
        rescue IMS::LTI::Errors::ToolProxyRegistrationError => e
          expect(e.response_body).to eq '{"error": "failed"}'
          expect(e.response_status).to eq 400
        end
      end

      it "doesn't set the reregistration_confirm_url if not provided" do
        response = double('response', status: 201, body: '{"tool_proxy_guid": "another_guid"}')
        allow(faraday).to receive(:post) do |&arg|
          begin
            headers = {}
            request = double('request)', headers: headers).as_null_object
            arg.call request
            expect(headers['VND-IMS-CONFIRM-URL']).to be_nil
            response
          end
        end
        tool_proxy = IMS::LTI::Models::ToolProxy.new(id: 'some/json-ld/id', tool_proxy_guid: 'a_guid')
        subject.register_tool_proxy(tool_proxy)
      end

      it 'uses the reg_key and reg_password if a registration message' do
        allow(Faraday).to receive(:new) do |&arg|
          begin
            connection = spy
            arg.call connection
            expect(connection).to have_received(:request).with(:oauth, hash_including(consumer_key: reg_key, consumer_secret: reg_password))
            faraday
          end
        end
        response = double('response', status: 201, body: '{"tool_proxy_guid": "another_guid"}')
        allow(faraday).to receive(:post) { response }
        tool_proxy = IMS::LTI::Models::ToolProxy.new(id: 'some/json-ld/id', tool_proxy_guid: 'a_guid')
        subject.register_tool_proxy(tool_proxy)
      end

      context 'reregistration' do
        let(:reregistration_request) { IMS::LTI::Models::Messages::ToolProxyReregistrationRequest.new(tc_profile_url: '/profile/url') }
        subject { ToolProxyRegistrationService.new(reregistration_request) }
        let(:confirmation_url) { 'http://example.com/tool_proxy/123?correlation_id=3' }
        before(:each) do
          service_offered = IMS::LTI::Models::RestService.new(
              format: 'application/vnd.ims.lti.v2.toolproxy+json',
              action: 'POST'
          )
          tcp = IMS::LTI::Models::ToolConsumerProfile.new(service_offered: service_offered)
          allow(subject).to receive(:tool_consumer_profile) { tcp }
          allow(faraday).to receive(:post) { response }
        end

        it "doesn't throw an error if the response is 200 and the message is ToolProxyReregistration" do
          allow(response).to receive(:status) { 200 }
          allow(response).to receive(:body) { '{"tool_proxy_guid": "another_guid"}' }
          tool_proxy = IMS::LTI::Models::ToolProxy.new(id: 'some/json-ld/id', tool_proxy_guid: 'a_guid')

          new_tp = subject.register_tool_proxy(tool_proxy)

          expect(tool_proxy.tool_proxy_guid).to eq 'a_guid'
          expect(new_tp.id).to eq 'some/json-ld/id'
          expect(new_tp.tool_proxy_guid).to eq 'another_guid'

        end

        it 'sets the reregistration_confirm_url in the header if provided' do
          response = double('response', status: 200, body: '{"tool_proxy_guid": "another_guid"}')
          allow(faraday).to receive(:post) do |&arg|
            begin
              headers = {}
              request = double('request)', headers: headers).as_null_object
              arg.call request
              expect(headers['VND-IMS-CONFIRM-URL']).to eq confirmation_url
              response
            end
          end
          tool_proxy = IMS::LTI::Models::ToolProxy.new(id: 'some/json-ld/id', tool_proxy_guid: 'a_guid')
          subject.register_tool_proxy(tool_proxy, confirmation_url)
        end

        it 'uses the tool_proxy guid, and secret if a reregistration message' do
          tool_proxy_guid = 'my_guid'
          shared_secret = 'shh...'
          allow(Faraday).to receive(:new) do |&arg|
            begin
              connection = spy
              arg.call connection
              expect(connection).to have_received(:request).with(:oauth, hash_including(consumer_key: tool_proxy_guid, consumer_secret: shared_secret))
              faraday
            end
          end
          response = double('response', status: 200, body: {tool_proxy_guid: tool_proxy_guid}.to_json)
          allow(faraday).to receive(:post) { response }
          tool_proxy = IMS::LTI::Models::ToolProxy.new(id: 'some/json-ld/id', tool_proxy_guid: tool_proxy_guid)
          subject.register_tool_proxy(tool_proxy, confirmation_url, shared_secret)
        end

      end

    end

    describe '#remove_invalid_capabilities!' do

      let(:message_handler) { IMS::LTI::Models::MessageHandler.new }

      before :each do
        tcp = IMS::LTI::Models::ToolConsumerProfile.new
        tcp.capability_offered = %w(basic-lti-launch-request Result.autocreate com.example.Person.name http://example.com/vocab#com.example.person.email)
        subject.instance_variable_set('@tool_consumer_profile', tcp)
      end

      it 'removes invalid items from enabled_capabilities' do
        message_handler.enabled_capability = %w(Result.autocreate invalid.capability)
        result = subject.remove_invalid_capabilities!(message_handler)
        expect(result[:invalid_capabilities]).to eq %w(invalid.capability)
        expect(message_handler.enabled_capability).to eq %w(Result.autocreate)
      end

      it 'removes messaging capabilities from enabled_capabilities' do
        message_handler.enabled_capability = %w(Result.autocreate basic-lti-launch-request)
        result = subject.remove_invalid_capabilities!(message_handler)
        expect(result[:invalid_capabilities]).to eq %w(basic-lti-launch-request)
        expect(message_handler.enabled_capability).to eq %w(Result.autocreate)
      end

      it 'removes invalid items from parameter' do
        p1 = IMS::LTI::Models::Parameter.new(name: 'my_variable', variable: 'com.example.Person.name')
        p2 = IMS::LTI::Models::Parameter.new(name: 'my_invalid_variable', variable: 'com.invalid.variable')
        message_handler.parameter = [p1, p2]
        result = subject.remove_invalid_capabilities!(message_handler)

        expect(result[:invalid_parameters]).to eq [p2]
        expect(message_handler.parameter).to eq [p1]
      end

    end
  end
end