# beacuse of how ruby does class loading we need to require the middleware here
require_relative '../oauth_faraday_middleware'

# We are prepending the IMS::LTI::OAuthFaradayMiddleware to the OAuth middleware as a nicer monkeypatch
# It is going to put the module in the front of the ancestory chain, so it's methods get called before the
# middleware methods get called
FaradayMiddleware::OAuth.prepend(IMS::LTI::OAuthFaradayMiddleware)

# add support for the body_hash option to simple_oauth
SimpleOAuth::Header::ATTRIBUTE_KEYS << :body_hash unless SimpleOAuth::Header::ATTRIBUTE_KEYS.include? :body_hash

module IMS::LTI::Services
  class OAuth1Client

    attr_accessor :token, :base_url
    attr_writer :connection

    def initialize(consumer_key:, consumer_secret:, base_url: nil)
      @consumer_key = consumer_key
      @consumer_secret = consumer_secret
      @base_url = nil
    end

    def connection
      @connection ||= Faraday.new base_url do |conn|
        conn.request :oauth, {consumer_key: @consumer_key, consumer_secret: @consumer_secret}
        conn.adapter :net_http
      end
    end

  end
end