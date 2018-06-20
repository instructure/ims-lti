module Ims::Lti::Models::Messages
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

    describe '#parameters' do
      it 'contains all available message parameters' do
        expect(message.parameters.keys).to match_array [
          :lti_message_type,
          :lti_version,
          :content_items,
          :data,
          :lti_msg,
          :lti_log,
          :lti_errormsg,
          :lti_errorlog
        ]
      end
    end
  end
end