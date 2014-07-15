require 'spec_helper'

module IMS::LTI::Models
  describe ServiceProvider do

    it 'serialize to JSON' do
      subject.id = 'id_1'
      subject.guid = 'my_guid'
      subject.timestamp = Time.parse('2014-05-16T09:30:16.338-06:00')
      subject.service_provider_name = double('description', as_json: {'json_key'=> 'json_value'})
      subject.description = double('description', as_json: {'json_key'=> 'json_value'})
      subject.support = double('description', as_json: {'json_key'=> 'json_value'})

      json = subject.as_json
      timestamp = json.delete('timestamp')
      expect(timestamp.to_i).to eq Time.parse('2014-05-16T09:30:16.338-06:00').to_i
      expect(json).to eq ({
        '@id' => 'id_1',
        'guid' => 'my_guid',
        'service_provider_name' => {'json_key'=> 'json_value'},
        'description' => {'json_key'=> 'json_value'},
        'support' => {'json_key'=> 'json_value'}
      })
    end

  end
end