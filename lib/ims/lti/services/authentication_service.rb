module IMS::LTI::Services
  class AuthenticationService

    attr_accessor :connection, :iss, :aud, :sub, :secret, :grant_type,
                  :additional_claims, :additional_params
    attr_writer :secret

    def initialize(iss:, aud:, sub:, secret:)
      @iss = iss
      @aud = aud
      @sub = sub
      @secret = secret
      @additional_claims = {}
      @additional_params = {}
      @grant_type = 'urn:ietf:params:oauth:grant-type:jwt-bearer'
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
          iss: iss,
          sub: sub,
          aud: aud.to_s,
          iat: Time.now.to_i,
          exp: 1.minute.from_now,
          jti: SecureRandom.uuid
        )
        assertion.merge!(@additional_claims)
        assertion = assertion.sign(@secret, :HS256).to_s
        body = {
          grant_type: grant_type,
          assertion: assertion
        }
        body.merge!(@additional_params)
        response = connection.post(aud, body)
        logger.debug('+++++++ Access Token Request +++++++')
        logger.debug("aud: #{aud}")
        logger.debug("grant_type: #{grant_type}")
        logger.debug(assertion)
        logger.debug(response.to_json)
        logger.debut('++++++++++++++++++++++++++++++++++++')
        raise IMS::LTI::Errors::AuthenticationFailedError.new(response: response) unless response.success?
        @_response_time = Time.now
        JSON.parse(response.body)
      end
    end

  end
end
