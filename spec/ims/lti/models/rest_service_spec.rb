require 'spec_helper'

module IMS::LTI::Models
  describe RestService do
    subject{RestService.new(endpoint: 'http://example.com/endpoint', format: ["my_fomat"], action: ["POST"], id: 'example.com:unique_id')}

    it 'converts to a RestServiceProfile' do
      profile = subject.profile

      expect(profile).to be_a RestServiceProfile
      expect(profile.type).to eq 'RestServiceProfile'
      expect(profile.service).to eq 'http://example.com/endpoint'
      expect(profile.action).to eq ["POST"]
    end
  end
end