require 'spec_helper'

module IMS::LTI::Services
  describe RequestService do
    let(:body) { 'body content' }
    let(:status) { 200 }
    let(:headers) { {header_one: 'header one value'} }
    let(:params) { {param_one: 'param one value'} }
    let(:request_service) { RequestService.new(body: body, headers: headers, params: params) }

    let(:response_body) { 'response body' }
    let(:faraday_response_double) { double(body: response_body, status: status) }
    let(:faraday_instance_double) do
      double(post: faraday_response_double,
             get: faraday_response_double,
             delete: faraday_response_double,
             put: faraday_response_double)
    end

    before do
      allow(Faraday).to receive(:new).and_return(faraday_instance_double)
    end

    it "has a 'get' method" do
      expect(request_service.respond_to?(:get)).to be_truthy
    end

    it "has a 'post' method" do
      expect(request_service.respond_to?(:post)).to be_truthy
    end

    it "has a 'put' method" do
      expect(request_service.respond_to?(:put)).to be_truthy
    end

    it "has a 'delete' method" do
      expect(request_service.respond_to?(:delete)).to be_truthy
    end

    it 'includes the body in the response' do
      response = request_service.post('http://www.test.com/post-here')
      expect(response.body).to eq response_body
    end

    it 'includes the status in the response' do
      response = request_service.post('http://www.test.com/post-here')
      expect(response.status).to eq status
    end

    it 'raises an error if an unsupported method is used' do
      expect { request_service.send_request('banana', 'http://www.test.com/post-here') }.to raise_exception RequestServiceError
    end
  end
end
