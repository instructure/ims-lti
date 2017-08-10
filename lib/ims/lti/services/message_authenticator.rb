module IMS::LTI::Services
  class MessageAuthenticator

    attr_reader :launch_url, :params, :message, :simple_oauth_header, :signature, :consumer_key

    def initialize(launch_url, params, secret)
      @launch_url = launch_url
      @params = params
      @options, @parsed_params = parse_params(params)
      @consumer_key = @options[:consumer_key]
      @signature = @parsed_params.delete(:oauth_signature)
      @secret = secret
    end


    def valid_signature?
       message.jwt ? valid_jwt? : simple_oauth_header.valid?(signature: signature)
    end

    def message
      @message ||= begin
        m = IMS::LTI::Models::Messages::Message.generate(params)
        m.launch_url = launch_url
        m
      end
    end

    def simple_oauth_header
      @simple_oauth_header ||= begin
        @simple_oauth_header = SimpleOAuth::Header.new(
          :post, launch_url,
          @parsed_params,
          @options.merge(
            {
              consumer_key: consumer_key,
              consumer_secret: @secret
            }
          )
        )
        @simple_oauth_header
      end
    end

    def base_string
      simple_oauth_header.send(:signature_base)
    end

    def signed_params
      simple_oauth_header.signed_attributes.merge(@parsed_params)
    end


    private

    def valid_jwt?
      begin
        jwt = JSON::JWT.decode(message.jwt, @secret)
        aud1 = Addressable::URI.parse(jwt['aud'])
        aud2 = Addressable::URI.parse(launch_url)
        [aud1, aud2].each{ |aud| aud.fragment = '' }
        aud1.normalize == aud2.normalize
      rescue JSON::JWS::VerificationFailed
        false
      end
    end

    def parse_params(params)
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
