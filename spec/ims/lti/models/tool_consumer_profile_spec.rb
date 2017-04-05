require 'spec_helper'
module IMS::LTI::Models
  describe ToolConsumerProfile do

    let(:tcp) {ToolConsumerProfile.new}

    it 'should serialize to json' do
      tcp.id = 'my_id'
      tcp.lti_version = 'lti_v2p0'
      tcp.guid = 'my_guid'
      tcp.product_instance = double('product_instance', as_json: {'json_key' => 'json_value'})
      tcp.capability_offered = %w(123 abc)
      tcp.service_offered = double('service_offered', as_json: {'json_key' => 'json_value'})
      expect(tcp.as_json).to eq({
                                      '@context' => [described_class::CONTEXT],
                                      '@type' => described_class::TYPE,
                                      '@id' => 'my_id',
                                      'lti_version' => 'lti_v2p0',
                                      'guid' => 'my_guid',
                                      'product_instance' => {'json_key' => 'json_value'},
                                      'service_offered' => {'json_key' => 'json_value'},
                                      'capability_offered' => %w(123 abc)
                                    })

    end

    it 'pluralizes service_offered' do
      expect(tcp.services_offered).to eq []
    end

    it 'pluralizes capabilities_offered' do
      expect(tcp.capabilities_offered).to eq []
    end

    it 'pluralizes security_profile' do
      expect(tcp.security_profiles).to eq []
    end

    describe '#reregistration_capable?' do
      it 'must return true when the reregistration capability is present' do
        tcp.capability_offered = %w{ToolProxyReregistrationRequest}
        expect(tcp).to be_reregistration_capable
      end

      it 'must return false when the reregistration capability is not present' do
        tcp.capability_offered = %w{foo bar baz}
        expect(tcp).to_not be_reregistration_capable
      end
    end

    describe "supports_capabilities?" do
      let(:tcp){IMS::LTI::Models::ToolConsumerProfile.new(capability_offered: %w(User.name User.email))}

      it "returns true if it supports the provided capability" do
        expect(tcp.supports_capabilities?('User.name')).to eq true
      end

      it 'returns false if the provided capabilities are not supported' do
        expect(tcp.supports_capabilities?('User.invalide')).to eq false
      end

      it 'accepts multiple capabilities' do
        expect(tcp.supports_capabilities?('User.name', 'User.email')).to eq true
      end

    end

  end
end
