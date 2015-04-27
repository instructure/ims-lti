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
