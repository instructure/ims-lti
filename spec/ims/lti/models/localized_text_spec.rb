require 'spec_helper'


module IMS::LTI::Models
  describe LocalizedText do

    it 'serializes to json' do
      subject.default_value = 'default value'
      subject.key = 'key'
      expect(subject.as_json).to eq({
                                      'default_value' => 'default value',
                                      'key' => 'key'
                                    })
    end

    it 'deserializes JSON' do
      subject.from_json(fixture('models/localized_text.json').read)
      expect(subject.default_value).to eq 'LMS Corporation is a fictitious vendor of a Learning Management System'
      expect(subject.key).to eq 'product.vendor.description'
    end

    it 'creates a name with the key and default value' do
      name = described_class.new('default name', 'default.key')
      expect(name.default_value).to eq 'default name'
      expect(name.key).to eq 'default.key'
    end

  end
end