require 'spec_helper'

module IMS::LTI::Models
  describe ProductInstance do

    it 'serialize to JSON' do
      subject.guid = 'my_guid'
      subject.product_info = double('product_info', as_json: {'json_key'=> 'json_value'})
      subject.service_owner = double('service_owner', as_json: {'json_key'=> 'json_value'})
      subject.service_provider = double('service_provider', as_json: {'json_key'=> 'json_value'})
      subject.support = double('support', as_json: {'json_key'=> 'json_value'})
      expect(subject.as_json).to eq({
                                      'guid' => 'my_guid',
                                      'product_info' => {'json_key'=> 'json_value'},
                                      'service_owner' => {'json_key'=> 'json_value'},
                                      'service_provider' => {'json_key'=> 'json_value'},
                                      'support' => {'json_key'=> 'json_value'},
                                    })

    end

  end
end