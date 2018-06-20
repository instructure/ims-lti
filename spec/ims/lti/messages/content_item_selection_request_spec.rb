module Ims::Lti::Messages
  RSpec.describe ContentItemSelectionRequest do
    let(:content_item_return_url) { 'https://www.test.com/return' }
    let(:message) { ContentItemSelectionRequest.new }

    describe '#initialize' do
      it 'allows initializing with attributes' do
        new_message = ContentItemSelectionRequest.new(content_item_return_url: content_item_return_url)
        expect(new_message.content_item_return_url).to eq content_item_return_url
      end

      it 'defaults "lti_message_type" to "ContentItemSelectionRequest"' do
        expect(message.lti_message_type).to eq 'ContentItemSelectionRequest'
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
        message.accept_media_types = 'jpg'
        message.accept_presentation_document_targets = 'iframe'
        message.content_item_return_url = content_item_return_url
        expect(message).to be_valid
      end
    end
  end
end