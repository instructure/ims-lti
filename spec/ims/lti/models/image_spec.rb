module Ims::Lti::Models
  RSpec.describe Image do
    describe 'initialize' do
      it 'allows initializing with attributes' do
        new_content_item = Image.new(id: 'abc')
        expect(new_content_item.id).to eq 'abc'
      end
    end
  end
end