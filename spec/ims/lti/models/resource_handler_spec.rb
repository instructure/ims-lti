require 'spec_helper'
module IMS::LTI::Models
  describe ResourceHandler do

    describe '#default_name' do

      it 'returns the default name' do
        subject.resource_name = LocalizedName.new('default_name', 'default.key')
        expect(subject.default_name).to eq 'default_name'
      end

    end

    it 'pluralizes message' do
      expect(subject.messages).to eq []
    end


    describe '#default_description' do

      it 'returns the default description' do
        subject.description = LocalizedText.new('default_desc', 'default.desc.key')
        expect(subject.default_description).to eq 'default_desc'
      end

    end

  end
end