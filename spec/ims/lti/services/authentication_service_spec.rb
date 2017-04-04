require "spec_helper"

module IMS::LTI::Services

  RSpec::Matchers.define :an_assertion_containing do |x|
    match do |actual|
      jwt = JSON::JWT.decode(actual[:body][:assertion], :skip_verification)
      jwt.merge(x) == jwt
    end
  end

  describe AuthenticationService do

    let(:aud) { 'http://tc.example.com/authorization' }
    let(:sub) { 'consumer_key' }
    let(:secret) { 'consumer_secret' }
    let(:iss) { 'tp.example.com' }
    let(:access_token) { "dkj4985kjaIAJDJ89kl8rkn5" }
    let(:expires_in) { 3600 }
    let(:token_response) do
      {
        "access_token" => access_token,
        "token_type" => "Bearer",
        "expires_in" => expires_in
      }
    end
    let(:faraday_stub) do
      Faraday::Adapter::Test::Stubs.new do |stub|
        stub.post(aud) { [200, {}, token_response] }
      end
    end

    let(:faraday) do
      Faraday.new do |builder|
        builder.adapter :test, faraday_stub
      end
    end

    let(:auth_service) { AuthenticationService.new(iss: iss, aud: aud, sub: sub, secret: secret) }

    before(:each) do
      auth_service.connection = faraday
    end

    describe '#access_token' do
      it 'retrieves the access token' do
        expect(auth_service.access_token).to eq access_token
      end

      it 'only makes a call to retrieve the access token once' do
        expect(faraday).to receive(:post).once.and_call_original
        2.times { auth_service.access_token }
      end

      it 'can use additional claims' do
        code = '12345'
        auth_service = AuthenticationService.new(iss: iss, aud: aud, sub: sub, secret: secret, additional_claims: {code: code})
        auth_service.connection = faraday
        expect(faraday).to receive(:post)
                             .with(aud, an_assertion_containing({code: code})).and_call_original
        auth_service.access_token
      end

      describe 'unsuccessful request' do
        let(:faraday_stub) do
          Faraday::Adapter::Test::Stubs.new do |stub|
            stub.post(aud) { [401, {}, token_response] }
          end
        end

        it 'raises an exception if the response is invalid' do
          expect { auth_service.access_token }.to raise_error(
                                                    IMS::LTI::Errors::AuthenticationFailedError
                                                  )
        end

        it 'includes the response object in the AuthenticationFailedError' do
          begin
            auth_service.access_token
          rescue IMS::LTI::Errors::AuthenticationFailedError => e
            expect(e.response).to_not be_nil
          end
        end

        it 'only caches the response if it was successful' do
          expect(faraday).to receive(:post).twice.and_call_original
          2.times { auth_service.access_token rescue nil }
        end

      end

      describe '#expiration' do

        it 'returns the expiration time' do
          Timecop.freeze do
            expect(auth_service.expiration).to eq(Time.now + expires_in)
          end
        end
      end

      describe "#invalidate!" do

        it 'removes the access token' do
          expect(faraday).to receive(:post).twice.and_call_original
          auth_service.access_token
          auth_service.invalidate!
          auth_service.access_token
        end

      end

      describe "expired?" do
        it 'returns true if it is expired' do
          auth_service.access_token
          Timecop.freeze(Time.now + expires_in + 10) do
            expect(auth_service.expired?).to be true
          end
        end

        it 'returns false if it is not expired' do
          expect(auth_service.expired?).to be false
        end

      end

    end
  end
end