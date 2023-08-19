require 'spec_helper'

module IMS::LTI::Services
  describe OAuth2Client do
    let(:base_url) { 'http://www.base.com' }
    let(:token) { 'my-api-token' }
    let(:request_service) { OAuth2Client.new(token: token, base_url: base_url) }

    around do |example|
      adapter = Faraday.default_adapter
      Faraday.default_adapter = :test
      example.call
    ensure
      Faraday.default_adapter = adapter
    end

    describe '#connection' do
      it 'populates the authorization header with the provided token' do
        if Gem::Version.new(Faraday::VERSION) < Gem::Version.new('1.0')
          expect(request_service.connection.headers['Authorization']).to eq "Bearer #{token}"
        else
          called = false
          request_service.connection.app.app.stubs.get('/') do |env|
            expect(env.request_headers['Authorization']).to eq "Bearer #{token}"
            called = true
          end
          request_service.connection.get('/')
          expect(called).to be true
        end
      end

      it 'sets the base url on the connection' do
        expect(request_service.connection.url_prefix).to eq URI.parse(base_url)
      end
    end
  end
end
