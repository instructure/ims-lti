require 'byebug'

module Ims::Lti::Models
  RSpec.describe Image do
    describe 'initialize' do
      it 'allows initializing with attributes' do
        new_content_item = Image.new(id: 'abc')
        expect(new_content_item.id).to eq 'abc'
      end
    end

    describe 'parameters' do
      it 'contains all available message parameters' do
        expect(Image.new.parameters.keys).to match_array [
          :height,
          :id,
          :width
        ]
      end
    end
  end
end