require 'spec_helper'

module IMS::LTI::Converters
  describe TimeJSONConverter do

    it 'parses a ruby date time to a string' do
      time = Time.parse('2014-05-16T09:30:16.338-06:00')
      expect(described_class.to_json_value(time)).to eq time
    end

  end
end