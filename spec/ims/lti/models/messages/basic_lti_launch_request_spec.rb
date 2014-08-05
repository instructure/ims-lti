require 'spec_helper'

module IMS::LTI::Models::Messages
  describe BasicLTILaunchRequest do

    it 'should have a default value for lti_message_type' do
      expect(subject.lti_message_type).to eq 'basic-lti-launch-request'

    end


  end
end