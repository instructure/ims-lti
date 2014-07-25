module IMS::LTI::Services
  class MessageService

    def initialize(key, secret)
      @credentials = {consumer_key: key, consumer_secret: secret}
    end

    def signed_params(url, message)
      params = message.post_params
      header = SimpleOAuth::Header.new(:post, url, params, @credentials)
      params = header.signed_attributes.merge(params)
      params
    end

    def valid_signature?(url, params)
      options, parsed_params = parse_params(params)
      signature = parsed_params.delete(:oauth_signature)
      header = SimpleOAuth::Header.new(:post, url, parsed_params, options.merge(@credentials))
      header.valid?(signature: signature)
    end

    private

    def parse_params(params)
      params.inject([{}, {}]) do |array, (k, v)|
        attr = k.to_s.sub('oauth_', '').to_sym
        if SimpleOAuth::Header::ATTRIBUTE_KEYS.include?(attr)
          array[0][attr] = v
        else
          array[1][k] = v
        end
        array
      end
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