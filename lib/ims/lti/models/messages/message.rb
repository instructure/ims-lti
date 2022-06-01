module IMS::LTI::Models::Messages
  class Message

    attr_reader :message_authenticator

    class << self

      def required_params
        supers_params('@required_params') | (@required_params || [])
      end

      def add_required_params(param, *params)
        add_params('@required_params', param, *params)
      end

      def recommended_params
        supers_params('@recommended_params') | (@recommended_params || [])
      end

      def add_recommended_params(param, *params)
        add_params('@recommended_params', param, *params)
      end

      def optional_params
        supers_params('@optional_params') | (@optional_params || [])
      end

      def add_optional_params(param, *params)
        add_params('@optional_params', param, *params)
      end

      def deprecated_params
        supers_params('@deprecated_params') | (@deprecated_params || [])
      end

      def add_deprecated_params(param, *params)
        add_params('@deprecated_params', param, *params)
      end

      def inherited(klass)
        @descendants ||= Set.new
        @descendants << klass
        superclass.inherited(klass) unless (self == Message)
      end

      def descendants
        @descendants || Set.new
      end

      # For signature generation -- see usage in signed_post_params
      def convert_param_values_to_crlf_endings(hash)
        hash.transform_values do |val|
          if val.is_a?(String)
            # Convert to all newlines first, for consistency, just in case there
            # is some weird mix of newlines & carriage returns in input
            val.encode(universal_newline: true).encode(crlf_newline: true)
          else
            val
          end
        end
      end

      private

      def add_params(instance_variable, param, *params)
        instance_var = self.instance_variable_get(instance_variable) || []
        instance_var |= params.unshift(param)
        self.instance_variable_set(instance_variable, instance_var)
        attr_accessor(params.shift, *params)
      end

      def parameters
        required_params + recommended_params + optional_params + deprecated_params
      end

      def supers_params(instance_variable)
        if name == "IMS::LTI::Models::Messages::Message"
          []
        else
          (superclass.instance_variable_get(instance_variable) || []) | superclass.send(:supers_params, instance_variable)
        end
      end

    end

    MESSAGE_TYPE = "".freeze

    LAUNCH_TARGET_IFRAME = 'iframe'
    LAUNCH_TARGET_WINDOW = 'window'

    EXTENSION_PREFIX = 'ext_'
    CUSTOM_PREFIX = 'custom_'

    OAUTH_KEYS = :oauth_callback, :oauth_consumer_key, :oauth_nonce, :oauth_signature, :oauth_signature_method,
      :oauth_timestamp, :oauth_token, :oauth_verifier, :oauth_version

    attr_accessor :launch_url, :jwt, *OAUTH_KEYS
    attr_reader :unknown_params, :custom_params, :ext_params

    add_required_params :lti_message_type, :lti_version

    def self.generate(launch_params)
      params = launch_params.key?('jwt') ? parse_jwt(jwt: launch_params['jwt']) : launch_params
      klass = self.descendants.select {|d| d::MESSAGE_TYPE == params['lti_message_type']}.first
      message = klass ? klass.new(params) : Message.new(params)
      message.jwt = launch_params['jwt'] if launch_params.key?('jwt')
      message
    end

    def self.parse_jwt(jwt:)
      decoded_jwt = JSON::JWT.decode(jwt, :skip_verification)
      params = decoded_jwt['org.imsglobal.lti.message'] || {}
      custom = params.delete(:custom)
      custom.each {|k,v| params["custom_#{k}"] = v }
      params['consumer_key'] = decoded_jwt[:sub]
      ext = params.delete(:ext)
      ext.each {|k,v| params["ext_#{k}"] = v }
      params
    end

    def initialize(attrs = {}, custom_params = {}, ext_params = {})

      @custom_params = custom_params
      @ext_params = ext_params
      @unknown_params = {}

      attrs.each do |k, v|
        str_key = k.to_s
        if str_key.start_with?(EXTENSION_PREFIX)
          @ext_params[str_key] = v
        elsif str_key.start_with?(CUSTOM_PREFIX)
          @custom_params[str_key] = v
        elsif !v.nil? && self.respond_to?(k.to_sym)
          send(("#{k}=").to_sym, v)

        else
          warn "Unknown parameter #{k}"
          @unknown_params[str_key] = v
        end
      end
    end

    def add_custom_params(params)
      params.each {|k, v| k.to_s.start_with?('custom_') ? @custom_params[k.to_s] = v : @custom_params["custom_#{k.to_s}"] = v}
    end

    def get_custom_params
      @custom_params.inject({}) {|hash, (k, v)| hash[k.gsub(/\Acustom_/, '')] = v; hash}
    end

    def get_ext_params
      @ext_params.inject({}) {|hash, (k, v)| hash[k.gsub(/\Aext_/, '')] = v; hash}
    end

    def post_params
      unknown_params.merge(@custom_params).merge(@ext_params).merge(parameters)
    end

    def jwt_params(private_key:, originating_domain:, algorithm: :HS256)
      { 'jwt' => to_jwt(private_key: private_key, originating_domain: originating_domain, algorithm: algorithm) }
    end

    def signed_post_params(secret)
      # The params will be used in an HTML form, and browsers will always use
      # newlines+carriage return line endings for submitted form data. The
      # signature needs to match, and signature generation does not add carriage
      # returns, so we ensure CRLF endings here.
      message_params = self.class.convert_param_values_to_crlf_endings(oauth_params.merge(post_params))
      @message_authenticator = IMS::LTI::Services::MessageAuthenticator.new(launch_url, message_params, secret)
      @message_authenticator.signed_params
    end

    def parameters
      collect_attributes(self.class.send("parameters"))
    end

    def required_params
      collect_attributes(self.class.required_params)
    end

    def recommended_params
      collect_attributes(self.class.recommended_params)
    end

    def optional_params
      collect_attributes(self.class.optional_params)
    end

    def deprecated_params
      collect_attributes(self.class.deprecated_params)
    end

    def oauth_params
      collect_attributes(OAUTH_KEYS)
    end

    def method_missing(meth, *args, &block)
      if match = /^(custom|ext)_([^=$]*)/.match(meth)
        param_type, key = match.captures
        param_hash = instance_variable_get("@#{param_type}_params".to_sym)
        meth =~ /=$/ ? param_hash[match.to_s] = args[0] : param_hash[match.to_s]
      else
        super
      end
    end

    def to_jwt(private_key:, originating_domain:, algorithm: :HS256)
      now = Time.now
      exp = now + 60 * 5
      ims = unknown_params.merge(parameters)
      ims[:custom] = get_custom_params
      ims[:ext] = get_ext_params
      claim = {
        iss: originating_domain,
        sub: consumer_key,
        aud: launch_url,
        iat: now,
        exp: exp,
        jti: SecureRandom.uuid,
        "org.imsglobal.lti.message" => ims
      }
      jwt = JSON::JWT.new(claim).sign(private_key, algorithm)
      jwt.to_s
    end

    alias_attribute :consumer_key, :oauth_consumer_key

    private

    def collect_attributes(attributes)
      attributes.inject({}) do |h, param|
        value = instance_variable_get("@#{param}")
        h[param.to_s] = value if value
        h
      end
    end

  end
end
