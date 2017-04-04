module IMS::LTI::Services
  class AuthenticationService

    attr_accessor :connection

    def initialize(iss:, aud:, sub:, secret:)
      @_iss = iss
      @_aud = aud
      @_sub = sub
      @_secret = secret
    end

    def connection
      @connection ||= Faraday.new
    end

    def access_token
      access_token_request['access_token']
    end

    def expiration
      expires_in = access_token_request['expires_in'].to_i
      @_response_time + expires_in
    end

    def expired?
      expiration < Time.now
    end

    def invalidate!
      @_access_token_request = nil
      @_response_time = nil
    end

    private

    def access_token_request
      @_access_token_request ||= begin
        assertion = JSON::JWT.new(
          iss: @_iss,
          sub: @_sub,
          aud: @_aud.to_s,
          iat: Time.now.to_i,
          exp: 1.minute.from_now,
          jti: SecureRandom.uuid
        )
        assertion = assertion.sign(@_secret, :HS256).to_s
        request = {
          body: {
            grant_type: 'urn:ietf:params:oauth:grant-type:jwt-bearer',
            assertion: assertion
          }
        }
        response = connection.post(@_aud, request)
        raise IMS::LTI::Errors::AuthenticationFailedError.new(response: response) unless response.success?
        @_response_time = Time.now
        response.body
      end
    end

  end
end