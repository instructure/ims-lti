require 'spec_helper'

module IMS::LTI::Models
  describe Vendor do

    it 'serializes to JSON' do
      subject.id = '1'
      subject.code = 'my_code'
      subject.vendor_name = double('vendor_name', as_json: {'json_key'=> 'json_value'})
      subject.description = double('description', as_json: {'json_key'=> 'json_value'})
      subject.website = 'http://some_website.invalid'
      subject.timestamp = Time.parse('2014-05-16T09:30:16.338-06:00')
      subject.contact = double('contact', as_json: {'json_key'=> 'json_value'})

      json = subject.as_json
      timestamp = json.delete('timestamp')
      expect(timestamp.to_i).to eq Time.parse('2014-05-16 09:30:16 -0600').to_i
      expect(json).to eq(
                        {
                          "code" => "my_code",
                          "vendor_name" => { "json_key" => "json_value" },
                          "description" => { "json_key" => "json_value" },
                          "website" => "http://some_website.invalid",
                          "contact" => { "json_key" => "json_value" },
                          "@id" => '1'
                        }
                      )
    end

    describe '#default_name' do

      it 'returns the default name' do
        subject.vendor_name = LocalizedName.new('default_name', 'default.key')
        expect(subject.default_name).to eq 'default_name'
      end

    end


    describe '#default_description' do

      it 'returns the default description' do
        subject.description = LocalizedText.new('default_desc', 'default.desc.key')
        expect(subject.default_description).to eq 'default_desc'
      end

    end


  end
end