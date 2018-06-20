require 'byebug'

module Ims::Lti::Models
  RSpec.describe ContentItem do
    describe 'initialize' do
      it 'allows initializing with attributes' do
        new_content_item = ContentItem.new(id: 'abc')
        expect(new_content_item.id).to eq 'abc'
      end
    end

    describe 'validations' do
      it 'is valid if "icon" and "thumbnail" are instances of Image' do
        content_item = ContentItem.new(
          icon: Image.new,
          thumbnail: Image.new
        )
        expect(content_item).to be_valid
      end

      it 'is not valid if "icon" is not an Image' do
        content_item = ContentItem.new(
          thumbnail: Image.new
        )
        expect(content_item).to be_invalid
      end

      it 'is not valid if "thumbnail" is not an Image' do
        content_item = ContentItem.new(
          icon: Image.new
        )
        expect(content_item).to be_invalid
      end

      it 'gives a helpful message if content item is invalid' do
        content_item = ContentItem.new(
          icon: Image.new
        )
        content_item.valid?
        expect(content_item.errors.messages[:thumbnail]).to match_array [
          'thumbnail must be an intance of Ims::Lti::Models::Image.'
        ]
      end
    end

    describe 'parameters' do
      it 'contains all available message parameters' do
        expect(ContentItem.new.parameters.keys).to match_array [
          :type,
          :id,
          :url,
          :title,
          :mediaType,
          :icon,
          :thumbnail,
          :text,
          :custom,
          :copyAdvice,
          :expiresAt,
          :presentationDocumentTarget,
          :windowTarget,
          :displayWidth,
          :displayHeight
        ]
      end
    end
  end
end