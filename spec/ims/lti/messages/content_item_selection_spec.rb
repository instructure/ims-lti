module Ims::Lti::Messages
  RSpec.describe ContentItemSelection do
    let(:lti_msg) { 'hello' }
    let(:message) { ContentItemSelection.new }

    describe '#initialize' do
      it 'allows initializing with attributes' do
        new_message = ContentItemSelection.new(lti_msg: lti_msg)
        expect(new_message.lti_msg).to eq lti_msg
      end

      it 'defaults "lti_message_type" to "ContentItemSelection"' do
        expect(message.lti_message_type).to eq 'ContentItemSelection'
      end

      it 'defaults "lti_version" to "LTI-1p0"' do
        expect(message.lti_version).to eq 'LTI-1p0'
      end
    end

    describe 'validations' do
      it 'is not valid when missing required parameters' do
        message.lti_message_type = nil
        expect(message).to be_invalid
      end

      it 'is valid when all required parameters are present' do
        expect(message).to be_valid
      end
    end
  end
end