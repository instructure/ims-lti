require 'spec_helper'

module IMS::LTI::Services
  describe OAuth2RequestService do
    let(:base_url) { 'http://www.base.com' }
    let(:token) { 'my-api-token' }
    let(:request_service) { OAuth2RequestService.new(token: token, base_url: base_url) }

    describe '#connection' do
      it 'populates the authorization header with the provided token' do
        expect(request_service.connection.headers['Authorization']).to eq "Bearer #{token}"
      end

      it 'setes the base url on the connection' do
        expect(request_service.connection.url_prefix).to eq URI.parse(base_url)
      end
    end
  end
end
