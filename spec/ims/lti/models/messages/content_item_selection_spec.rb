require 'spec_helper'

module IMS::LTI::Models::Messages
  describe ContentItemSelection do

    let(:default_params) { {lti_version: 'my_version'} }
    let(:content_item) do
      IMS::LTI::Models::ContentItems::ContentItem.new(
        media_type: 'my_media_type',
        text: 'some_text',
        thumbnail: IMS::LTI::Models::Image.new(id: 'test', height: 123, width: 456)
      )
    end
    let(:content_item_container) { IMS::LTI::Models::ContentItemContainer.new(graph: [content_item]) }

    it 'should have a default value for lti_message_type' do
      expect(subject.lti_message_type).to eq 'ContentItemSelection'
    end

    it "inherits parameters" do
      subject.lti_version = '123'
      expect(subject.lti_version).to eq '123'
      expect(subject.post_params.keys).to include('lti_version')
    end

    it 'returns optional param names' do
      expect(described_class.optional_params).to eq [:content_items, :data, :lti_msg, :lti_log, :lti_errormsg,
                                                     :lti_errorlog]
    end

    describe "#content_items=" do
      it 'parses json to ContentItem objects' do
        message = described_class.new content_items: content_item_container.to_json
        expect(message.content_items.first).to be_a IMS::LTI::Models::ContentItems::ContentItem
      end

      it 'does not decode the contents of json' do
        json_with_encoded_values = '{
          "@context": "http://purl.imsglobal.org/ctx/lti/v1/ContentItem",
            "@graph": [{
              "@type": "LtiLinkItem",
              "@id": "http://example.com/messages/launch",
              "url": "http://example.com/messages/launch?some_custom_json=%7B%22field1%22%3A%7B%22field2%22%3A3%7D%7D",
              "title": "Link Title",
              "text": "Link Text",
              "mediaType": "application/vnd.ims.lti.v1.ltilink",
              "windowTarget": "blank",
              "placementAdvice": {
                "presentationDocumentTarget": "window"
              }
            }]
          }'
          message = described_class.new content_items: json_with_encoded_values
          expect(message.content_items.first.url).to eq 'http://example.com/messages/launch?some_custom_json=%7B%22field1%22%3A%7B%22field2%22%3A3%7D%7D'
      end

      it 'assigns content item without parsing' do
        message = described_class.new content_items: [content_item]
        expect(message.content_items).to eq [content_item]
      end
    end

    describe "#parameters" do

      it 'converts content_items back into json' do
        message = described_class.new content_items: [content_item]
        expect(message.parameters['content_items']).to eq content_item_container.to_json
      end

    end

  end

end
