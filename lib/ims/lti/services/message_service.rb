module IMS::LTI::Services
  class MessageService

    def initialize(key, secret)
      @key = key
      @secret = secret
    end

    def signed_params(url, message)
      signed_request = signed_request(url, message)

      params = {}
      CGI.parse(signed_request.body).each do |key, value|
        params[key] = value.first
      end
      params
    end

    def valid_signature?(url, params)
      request = {
          'method' => 'POST',
          'uri' => url,
          'parameters' => params
      }

      OAuth::Signature.build(request, :consumer_secret => @secret).verify()
    end

    private

    def signed_request(url, message)
      uri = URI.parse(url)
      oauth_consumer = OAuth::Consumer.new(@key, @secret, {
          :site => "#{uri.scheme}://#{uri.host}",
          :scheme => :body
      })
      request = oauth_consumer.create_signed_request(:post, uri.request_uri, nil, {}, message.post_params)

      request
    end
  end
end