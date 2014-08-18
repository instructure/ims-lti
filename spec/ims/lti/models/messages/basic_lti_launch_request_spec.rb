require 'spec_helper'

module IMS::LTI::Models::Messages
  describe BasicLTILaunchRequest do

    it 'should have a default value for lti_message_type' do
      expect(subject.lti_message_type).to eq 'basic-lti-launch-request'
    end

    it "inherits parameters from $Message" do
      subject.user_id = '123'
      expect(subject.user_id).to eq '123'
      expect(subject.post_params.keys).to include('user_id')
    end


  end
end