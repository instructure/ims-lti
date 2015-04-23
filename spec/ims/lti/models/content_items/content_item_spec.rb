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

      it 'returns a LtiLink when the type is LtiLink' do
        subject.type = 'LtiLink'
        expect(described_class.from_json(subject.to_json)).to be_a LtiLink
      end

    end

  end
end

