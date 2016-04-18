require 'spec_helper'

module IMS::LTI::Errors
  describe ToolProxyRegistrationError do

    it 'sets the response_body attribute' do
      s = described_class.new(401, 'test')
      expect(s.response_body).to eq 'test'
      expect(s.response_status).to eq 401
    end

    it 'must construct a descriptive message from the constructor arguments' do
      exception = described_class.new(401, 'test')
      expect(exception.message).to include '401'
      expect(exception.message).to include 'test'
    end
  end
end
