require 'spec_helper'
module IMS::LTI::Models
  describe ToolProfile do

    describe '#base_message_url' do

      it 'returns the default_message_url' do
        choice1 = double('base_choice', default_message_url: '')
        choice2 = double('base_choice', default_message_url: 'http://base-url.com')
        subject.base_url_choice = [choice1, choice2]
        expect(subject.base_message_url).to eq 'http://base-url.com'
      end

      it 'pluralizes resource_handler' do
        expect(subject.resource_handlers).to eq []
      end

      it 'pluralizes message' do
        expect(subject.messages).to eq []
      end

    end


  end
end