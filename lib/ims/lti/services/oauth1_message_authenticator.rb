module IMS::LTI::Services
  class OAuth1MessageAuthenticator

    attr_reader :message, :simple_oauth_header

    def initialize(message, secret)
      @message = message
      @secret = secret
    end

    def valid_signature?
      simple_oauth_header.valid?(signature: message.oauth_signature)
    end

    def simple_oauth_header
      @simple_oauth_header ||= begin
        SimpleOAuth::Header.new(
          :post, message.launch_url,
          params,
          options
        )
      end
    end

    def base_string
      simple_oauth_header.send(:signature_base)
    end

    def signed_params
      simple_oauth_header.signed_attributes.merge(params)
    end

    def options
      @options ||= parsed_params[0].merge(
        consumer_key: message.oauth_consumer_key,
        consumer_secret: @secret,
        callback: 'about:blank'
      )
    end

    def params
      @params ||= parsed_params[1]
    end

    private

    def parsed_params
      @_parsed_params ||= begin
        oauth_params = message.oauth_params.clone
        oauth_params.delete('oauth_signature')
        params = message.post_params.merge(oauth_params)
        params.inject([{}, {}]) do |array, (k, v)|
          attr = k.to_s.sub('oauth_', '').to_sym
          if SimpleOAuth::Header::ATTRIBUTE_KEYS.include?(attr)
            array[0][attr] = v
          else
            array[1][k.to_sym] = v
          end
          array
        end
      end
    end

  end
end