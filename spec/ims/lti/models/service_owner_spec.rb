require 'spec_helper'

module IMS::LTI::Models
  describe ServiceOwner do

    it 'serializes to JSON' do
      subject.timestamp = Time.parse('2014-05-16T09:30:16.338-06:00')
      subject.service_owner_name = double('service_owner_name', as_json: {'json_key'=> 'json_value'})
      subject.description = double('description', as_json: {'json_key'=> 'json_value'})

      json = subject.as_json
      timestamp = json.delete('timestamp')
      expect(timestamp.to_i).to eq Time.parse('2014-05-16T09:30:16.338-06:00').to_i
      expect(json).to eq({
                           'service_owner_name' => {'json_key'=> 'json_value'},
                           'description' => {'json_key'=> 'json_value'}
                         })

    end
  end
end