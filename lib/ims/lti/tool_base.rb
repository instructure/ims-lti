module IMS::LTI
  class ToolBase

    # OAuth credentials
    attr_accessor :consumer_key, :consumer_secret

    def initialize(consumer_key, consumer_secret)
      @consumer_key = consumer_key
      @consumer_secret = consumer_secret
    end

    # Convenience method for doing oauth signed requests to services that
    # aren't supported by this library
    def post_service_request(url, content_type, body)
      IMS::LTI::post_service_request(@consumer_key,
                                     @consumer_secret,
                                     url,
                                     content_type,
                                     body)
    end
  end
end