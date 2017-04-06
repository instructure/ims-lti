module IMS::LTI::Services
  class ApiService
    attr_accessor :authentication_service
    attr_accessor :iss

    def initialize(iss: nil)
      @iss = iss
    end

    def tp_registration_service(registration_request:)
      @authentication_service ||= authentication_service_from_registration_request(
        registration_request: registration_request)

      api_client = if registration_request.oauth2_access_token_url
                     OAuth2Client.new(token: authentication_service.access_token)
                   else
                     OAuth1Client.new(
                       consumer_key: registration_request.reg_key,
                       consumer_secret: registration_request.reg_password
                     )
                   end
      ToolProxyRegistrationService.new(registration_request, api_client)
    end

    def authentication_service_from_registration_request(registration_request:)
      iss ||= URI.parse(registration_request.launch_url).host
      @authentication_service = AuthenticationService.new(
        iss: iss,
        aud: registration_request.oauth2_access_token_url,
        sub: registration_request.reg_key,
        secret: registration_request.reg_password
      )
    end

  end
end