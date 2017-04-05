module IMS::LTI::Services

  class OAuth2RequestService
    attr_accessor :token, :base_url
    attr_writer :connection

    def initialize(token:, base_url: nil)
      @base_url = base_url
      @token = token
    end

    def connection
      @connection ||= Faraday.new base_url do |conn|
        conn.authorization :Bearer, token
        conn.adapter :net_http
      end
    end
  end
end
