require 'spec_helper'

module IMS::LTI::Models
  describe Contact do

    it 'serializes to JSON' do
      subject.email = 'my_email@foo.com'
      json = subject.as_json
      expect(json).to eq({'email' => 'my_email@foo.com'})
    end

    it 'deserializes JSON' do
      subject.from_json(fixture('models/contact.json').read)
      expect(subject.email).to eq "support@lms.example.com"
    end

  end
end