module Ims::Lti::Messages
  RSpec.describe BasicLtiLaunchRequest do
    let(:resource_link_id) { '12345' }
    let(:message) { BasicLtiLaunchRequest.new }

    describe '#initialize' do
      it 'allows initializing with attributes' do
        new_message = BasicLtiLaunchRequest.new(resource_link_id: resource_link_id)
        expect(new_message.resource_link_id).to eq resource_link_id
      end

      it 'defaults "lti_message_type" to "basic-lti-launch-request"' do
        expect(message.lti_message_type).to eq 'basic-lti-launch-request'
      end

      it 'defaults "lti_version" to "LTI-1p0"' do
        expect(message.lti_version).to eq 'LTI-1p0'
      end
    end

    describe 'validations' do
      it 'is not valid when missing required parameters' do
        expect(message).to be_invalid
      end

      it 'is valid when all required parameters are present' do
        message.resource_link_id = resource_link_id
        expect(message).to be_valid
      end
    end
  end
end