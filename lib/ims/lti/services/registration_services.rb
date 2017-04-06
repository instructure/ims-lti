module IMS::LTI::Services
  class RegistrationServices
    attr_accessor :authentication_service, :iss, :message, :consumer_key, :consumer_secret

    def initialize(message:, iss: nil, consumer_key: nil, consumer_secret: nil)
      @message = message
      @iss = iss
      @consumer_key = consumer_key
      @consumer_secret = consumer_secret
    end

    def iss
      @iss ||= URI.parse(message.launch_url).host
    end

    def registration_service
      @registration_service ||= begin
        ToolProxyRegistrationService.new(message: message, api_client: api_client)
      end
    end

    def api_client
      @api_client ||= if message.oauth2_access_token_url
                        OAuth2Client.new(token: authentication_service.access_token)
                      else
                        OAuth1Client.new(
                          consumer_key: consumer_key || message.reg_key,
                          consumer_secret: consumer_secret || message.reg_password
                        )
                      end
    end

    def authentication_service
      @authentication_service ||= AuthenticationService.new(
        iss: iss,
        aud: message.oauth2_access_token_url,
        sub: consumer_key || message.reg_key,
        secret: consumer_secret || message.reg_password
      )
    end

  end
end