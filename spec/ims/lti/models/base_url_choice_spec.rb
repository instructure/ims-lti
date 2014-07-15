require 'spec_helper'

module IMS::LTI::Models
  describe BaseUrlChoice do

    describe '#default_message_url' do

      it 'it returns the secure message base' do
        selector = BaseUrlSelector.new
        selector.applies_to = ['MessageHandler']
        subject.secure_base_url = 'http://secure.com/path'
        subject.selector = selector
        expect(subject.default_message_url).to eq 'http://secure.com/path'
      end

      it 'returns the default message base if there is no secure path' do
        selector = BaseUrlSelector.new
        selector.applies_to = ['MessageHandler']
        subject.default_base_url = 'http://base.com/path'
        subject.selector = selector
        expect(subject.default_message_url).to eq 'http://base.com/path'
      end

      it 'returns an empty string if there is no base url' do
        expect(subject.default_message_url).to eq ''
      end

    end

  end
end

