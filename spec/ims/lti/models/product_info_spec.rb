require 'spec_helper'

module IMS::LTI::Models
  describe ProductInfo do

    it 'serializes to JSON' do
      subject.product_name = double('description', as_json: {'json_key'=> 'json_value'})
      subject.product_version = '1.0'
      subject.description = double('description', as_json: {'json_key'=> 'json_value'})
      subject.technical_description = double('technical_description', as_json: {'json_key'=> 'json_value'})
      subject.product_family = double('product_family', as_json: {'json_key'=> 'json_value'})

      expect(subject.as_json).to eq({
                                      'product_name' => {'json_key' => 'json_value'},
                                      'product_version' => '1.0',
                                      'description' => {'json_key' => 'json_value'},
                                      'technical_description' => {'json_key' => 'json_value'},
                                      'product_family' => {'json_key' => 'json_value'}
                                    })

    end

    it 'creates the product name' do
      subject.create_product_name('product name')
      expect(subject.product_name.default_value).to eq 'product name'
      expect(subject.product_name.key).to eq 'product.name'
    end

    it 'creates the description name' do
      subject.create_description('product description')
      expect(subject.description.default_value).to eq 'product description'
      expect(subject.description.key).to eq 'product.description'
    end

  end
end