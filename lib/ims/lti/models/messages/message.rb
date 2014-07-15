module IMS::LTI::Models::Messages
  class Message < IMS::LTI::Models::LTIModel
    LAUNCH_TARGET_IFRAME = 'iframe'
    LAUNCH_TARGET_WINDOW = 'window'

    EXTENSION_PREFIX = 'ext_'
    CUSTOM_PREFIX = 'custom_'

    add_attributes :lti_message_type, :lti_version, :user_id, :roles, :launch_presentation_local,
                   :launch_presentation_document_target, :launch_presentation_css_url, :launch_presentation_width,
                   :launch_presentation_height

    def initialize(attrs = {})
      @custom_params = {}
      @ext_params = {}
      attributes = {}

      attrs.each do |k,v|
        str_key = k.to_s
        if str_key.start_with?(EXTENSION_PREFIX)
          @ext_params[str_key.sub(EXTENSION_PREFIX, '')] = v
        elsif str_key.start_with?(CUSTOM_PREFIX)
          @custom_params[str_key.sub(CUSTOM_PREFIX, '')] = v
        else
          attributes[k] = v
        end
      end

      super(attributes)
    end

    def post_params
      get_custom_params.merge(get_ext_params).merge(attributes)
    end

    def get_ext_params
      params = {}
      @ext_params.each { |k, v| params["#{EXTENSION_PREFIX}#{k}"] = v }
      params
    end

    def get_custom_params
      params = {}
      @custom_params.each { |k, v| params["#{CUSTOM_PREFIX}#{k}"] = v }
      params
    end

    def method_missing(meth, *args, &block)
      if match = /^(custom|ext)_([^=$]*)/.match(meth)
        param_type, key = match.captures
        param_hash = instance_variable_get("@#{param_type}_params".to_sym)
        meth =~ /=$/ ? param_hash[key] = args[0] : param_hash[key]
      else
        super
      end
    end

    private
  end
end