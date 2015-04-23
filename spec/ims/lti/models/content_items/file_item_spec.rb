require 'spec_helper'

module IMS::LTI::Models::ContentItems
  describe FileItem do

    it 'inherits from ContentItem' do
      subject.id = 123
      expect(subject.id).to eq 123
    end

  end
end

