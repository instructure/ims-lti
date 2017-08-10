require 'spec_helper'
module IMS::LTI::Models
  describe ToolConsumerProfile do

    subject(:tool_consumer_profile) { ToolConsumerProfile.new}

    it 'should serialize to json' do
      subject.id = 'my_id'
      subject.lti_version = 'lti_v2p0'
      subject.guid = 'my_guid'
      subject.product_instance = double('product_instance', as_json: {'json_key' => 'json_value'})
      subject.capability_offered = %w(123 abc)
      subject.service_offered = double('service_offered', as_json: {'json_key' => 'json_value'})
      expect(subject.as_json).to eq({
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
      expect(subject.services_offered).to eq []
    end

    it 'pluralizes capabilities_offered' do
      expect(subject.capabilities_offered).to eq []
    end

    it 'pluralizes security_profile' do
      expect(subject.security_profiles).to eq []
    end

    describe '#security_profile_by_name' do
      let(:security_profile) {IMS::LTI::Models::SecurityProfile.new(security_profile_name: 'test1', digest_algorithm: 'invalid')}

      it 'looks up the profile by name' do
        tool_consumer_profile.security_profile = [security_profile]
        profile = tool_consumer_profile.security_profile_by_name(security_profile_name: security_profile.security_profile_name)
        expect(profile).to eq security_profile
      end
    end

    describe '#reregistration_capable?' do
      it 'must return true when the reregistration capability is present' do
        subject.capability_offered = %w{ToolProxyUpdateRequest}
        expect(subject).to be_reregistration_capable
      end

      it 'must return false when the reregistration capability is not present' do
        subject.capability_offered = %w{foo bar baz}
        expect(subject).to_not be_reregistration_capable
      end
    end
  end
end
