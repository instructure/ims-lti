require "spec_helper"

module IMS::LTI::Services
  describe RegistrationServices do

    let(:reg_key) { 'reg_key' }
    let(:reg_password) { 'reg_password' }
    let(:launch_url) { 'http://example.com/launch' }
    let(:registration_request) do
      reg_req = IMS::LTI::Models::Messages::RegistrationRequest.new(
        oauth2_access_token_url: 'http://example.com/authorization',
        reg_key: reg_key,
        reg_password: reg_password
      )
      reg_req.launch_url = launch_url
      reg_req
    end
    let(:reg_services) { RegistrationServices.new(message: registration_request) }

    describe '#tp_registration_service' do
      let(:access_token) { 'access_token' }
      let(:auth_service) { double('auth_service', access_token: access_token) }
      let(:reg_services) do
        serv = RegistrationServices.new(message:registration_request)
        serv.authentication_service = auth_service
        serv
      end
      context 'OAuth2' do
        it 'uses the OAut2 client if the oauth2_access_token_url is present' do
          reg_service = reg_services.registration_service
          expect(reg_service.api_client).to be_a(OAuth2Client)
        end
        it 'uses an existing authentication_service if one is available' do
          reg_services.registration_service
          expect(auth_service).to have_received(:access_token)
        end
        it 'creates a new authentication_service if one is not available' do
          reg_services.authentication_service = nil
          expect(AuthenticationService).to receive(:new).and_return(auth_service)
          reg_services.registration_service
        end
        it 'creates the OAuth2Client using the access token form the authentication_service' do
          token = reg_services.registration_service.api_client.token
          expect(token).to eq access_token
        end
      end

      context 'OAuth1' do
        let(:registration_request) do
          reg_req = IMS::LTI::Models::Messages::RegistrationRequest.new(
            reg_key: reg_key,
            reg_password: reg_password
          )
          reg_req.launch_url = launch_url
          reg_req
        end

        let(:oauth1_double) { double('oauth1 client') }

        it 'uses the OAut1 client if the oauth2_access_token_url is not present' do
          expect(OAuth1Client).to receive(:new)
          reg_services.registration_service

        end
        it 'sets the consumer key from the registration_request' do
          expect(OAuth1Client).to receive(:new).with(hash_including(consumer_key: reg_key))
          reg_services.registration_service
        end

        it 'sets the secret from the registration_request' do
          expect(OAuth1Client).to receive(:new).with(hash_including(consumer_secret: reg_password))
          reg_services.registration_service
        end

      end
    end

    describe '#authentication_service_from_registration_request' do
      it 'uses an existing iss if one is available' do
        iss = 'test_iss'
        reg_services.iss = iss
        auth_serv = reg_services.authentication_service
        expect(auth_serv.iss).to  eq iss
      end
      it 'sets the iss to the host of the launch url if an iss does not exist' do
        auth_serv = reg_services.authentication_service
        expect(auth_serv.iss).to  eq 'example.com'
      end
    end

  end
end