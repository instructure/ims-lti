require 'spec_helper'

module IMS::LTI::Models::ContentItems
  describe ContentItem do


    describe "#from_json" do

      it 'returns a ContentItem object when the type is "ContentItem"' do
        subject.type = 'ContentItem'
        expect(described_class.from_json(subject.to_json)).to be_a ContentItem
      end

      it 'returns a FileItem object when the type is "FileItem"' do
        subject.type = 'FileItem'
        expect(described_class.from_json(subject.to_json)).to be_a FileItem
      end

      it 'returns a LtiLinkItem when the type is LtiLinkItem' do
        subject.type = 'LtiLinkItem'
        expect(described_class.from_json(subject.to_json)).to be_a LtiLinkItem
      end

      it 'returns a LtiLinkItem when the type is LtiLink' do
        subject.type = 'LtiLink'
        expect(described_class.from_json(subject.to_json)).to be_a LtiLinkItem
      end

      it 'creates a ContentItem object if the type is unkown' do
        subject.type = 'Unkown'
        expect(described_class.from_json(subject.to_json)).to be_a ContentItem
      end

      it 'converts json to a content_item' do
        json = {
              "@type" => "LtiLinkItem",
              "@id" => "http://localhost:4001/messages/blti",
              "url" => "http://localhost:4001/messages/blti",
              "title" => "Test Lti Tool",
              "mediaType" => "application/vnd.ims.lti.v1.ltilink",
              "placementAdvice" => {
                "displayWidth" => 800,
                "presentationDocumentTarget" => "iframe",
                "displayHeight" => 600
              }
        }.to_json
        content_item = described_class.from_json(json)
        expect(content_item).to be_a LtiLinkItem
        expect(content_item.placement_advice.presentation_document_target).to eq 'iframe'
      end


    end

  end
end
