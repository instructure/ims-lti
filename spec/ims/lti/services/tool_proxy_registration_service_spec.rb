require 'spec_helper'

module IMS::LTI::Services
  describe ToolProxyRegistrationService do
    let(:registration_request) {IMS::LTI::Models::Messages::RegistrationRequest.new(tc_profile_url: '/profile/url')}
    let(:faraday) {double}
    subject{ToolProxyRegistrationService.new(registration_request)}

    before(:each) do
      allow(Faraday).to receive(:new) {faraday}
    end

    describe '#tool_consumer_profile' do
      it 'gets the ToolConsumerProfile' do
        expect(faraday).to receive(:get).with('/profile/url') {double(body: '{"id": "profile_id"}')}

        tcp = subject.tool_consumer_profile

        expect(tcp).to be_a IMS::LTI::Models::ToolConsumerProfile
        expect(tcp.id).to eq 'profile_id'
      end
    end

    describe '#service_profiles' do
      it 'maps the ToolConsumer.services_offered to rest service profiles' do
        service_offered = []
        3.times {service_offered << IMS::LTI::Models::RestService.new}
        tcp = IMS::LTI::Models::ToolConsumerProfile.new(service_offered: service_offered)
        allow(subject).to receive(:tool_consumer_profile) {tcp}

        service_profiles = subject.service_profiles
        expect(service_profiles.size).to eq 3
        service_profiles.each {|sp| expect(sp).to be_a IMS::LTI::Models::RestServiceProfile}
      end
    end

    describe '#register_tool_proxy' do
      let(:response) {double}
      before(:each) do
        service_offered = IMS::LTI::Models::RestService.new(
            format: 'application/vnd.ims.lti.v2.toolproxy+json',
            action: 'POST'
        )
        tcp = IMS::LTI::Models::ToolConsumerProfile.new(service_offered: service_offered)
        allow(subject).to receive(:tool_consumer_profile) {tcp}
        allow(faraday).to receive(:post) {response}
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
    end

  end
end