module IMS::LTI::Services

  class OAuth2Client
    attr_accessor :token, :base_url
    attr_writer :connection

    def initialize(token:, base_url: nil)
      @base_url = base_url
      @token = token
    end

    def connection
      @connection ||= Faraday.new base_url do |conn|
        if Gem::Version.new(Faraday::VERSION) < Gem::Version.new('1.0')
          conn.authorization :Bearer, token
        else
          conn.request :authorization, 'Bearer', token
        end
      end
    end
  end
end
