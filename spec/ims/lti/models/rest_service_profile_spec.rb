require 'spec_helper'

module IMS::LTI::Models
  describe RestServiceProfile do
    subject{RestServiceProfile.new(action: "POST")}
    it 'pluralizes action' do
      expect(subject.actions).to eq ["POST"]
    end
  end
end