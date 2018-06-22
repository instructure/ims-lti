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
          thumbnail: Image.new,
          mediaType: 'text/html'
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

      it 'is not valid if missing required parameters' do
        expect(ContentItem.new).to be_invalid
      end

      it 'is valid if all required parameters are present' do
        expect(ContentItem.new(mediaType: 'text/html')).to be_valid
      end

      it 'gives a helpful message if content item is invalid' do
        content_item = ContentItem.new(
          icon: Image.new,
          thumbnail: 'https://www.image.com'
        )
        content_item.valid?
        expect(content_item.errors.messages[:thumbnail]).to match_array [
          'thumbnail must be an intance of Ims::Lti::Models::Image'
        ]
      end
    end
  end
end