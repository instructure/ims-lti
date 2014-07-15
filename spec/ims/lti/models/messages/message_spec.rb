require 'spec_helper'

module IMS::LTI::Models::Messages
  describe Message do
    it "returns params for the message" do
      subject.lti_message_type = 'message-type'
      subject.user_id = '123456'

      params = subject.post_params
      expect(params['lti_message_type']).to eq('message-type')
      expect(params['user_id']).to eq('123456')
    end

    it 'returns custom params for the message' do
      subject.custom_name = 'my_custom_name'

      params = subject.post_params
      expect(params['custom_name']).to eq('my_custom_name')
    end

    it 'returns ext params for the message' do
      subject.ext_name = 'my_ext_name'

      params = subject.post_params
      expect(params['ext_name']).to eq('my_ext_name')
    end

    it 'sets a ext param' do
      subject.ext_name = 'my_ext_name'
      expect(subject.ext_name).to eq 'my_ext_name'
    end

    it 'sets an custom param' do
      subject.custom_name = 'my_custom_name'
      expect(subject.custom_name).to eq 'my_custom_name'
    end

    it 'returns all the custom params' do
      subject.custom_name = 'my_custom_name'
      subject.custom_number = '3'
      expect(subject.get_custom_params).to eq({'custom_name' => 'my_custom_name', 'custom_number' => '3'})
    end

    it 'returns all the ext params' do
      subject.ext_name = 'my_ext_name'
      subject.ext_number = '4'
      expect(subject.get_ext_params).to eq({'ext_name' => 'my_ext_name', 'ext_number' => '4'})
    end

    it 'sets configured attributes' do
      message = described_class.new(lti_message_type: 'message-type')
      expect(message.lti_message_type).to eq 'message-type'
    end

    it 'sets custom attributes' do
      message = described_class.new(custom_attribute: 'custom_value')
      expect(message.custom_attribute).to eq 'custom_value'
    end

    it 'sets extension attributes' do
      message = described_class.new(ext_attribute: 'extension_value')
      expect(message.ext_attribute).to eq 'extension_value'
    end

  end
end