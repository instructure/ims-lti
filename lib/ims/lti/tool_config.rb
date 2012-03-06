module IMS::LTI
  class ToolConfig
    attr_reader :custom_params, :extensions

    attr_accessor :title, :description, :launch_url, :secure_launch_url,
                  :icon, :secure_icon, :cartridge_bundle, :cartridge_icon,
                  :vendor_code, :vendor_name, :vendor_description, :vendor_url,
                  :vendor_contact_email

    def initialize(opts={})
      @custom_params = opts.delete("custom_params") || {}
      @extensions = opts.delete("extensions") || {}

      opts.each_pair do |key, val|
        self.send("#{key}=", val) if self.respond_to?("#{key}=")
      end
    end

    def set_custom_param(key, val)
      @custom_params[key] = val
    end

    def get_custom_param(key)
      @custom_params[key]
    end

    def set_ext_params(ext_key, ext_params)
      raise ArgumentError unless ext_params.is_a?(Hash)
      @extensions[ext_key] = ext_params
    end

    def get_ext_params(ext_key)
      @extensions[ext_key]
    end

    def set_ext_param(ext_key, param_key, val)
      @extensions[ext_key] ||= {}
      @extensions[ext_key][param_key] = val
    end

    def get_ext_param(ext_key, param_key)
      @extensions[ext_key] && @extensions[ext_key][param_key]
    end

    def to_xml(opts = {})
      raise IMS::LTI::InvalidLTIConfigError, "A launch url is required for an LTI configuration." unless self.launch_url || self.secure_launch_url
      
      builder = Builder::XmlMarkup.new(:indent => opts[:indent] || 0)
      builder.instruct!
      builder.cartridge_basiclti_link("xmlns" => "http://www.imsglobal.org/xsd/imslticc_v1p0",
                                      "xmlns:blti" => 'http://www.imsglobal.org/xsd/imsbasiclti_v1p0',
                                      "xmlns:lticm" => 'http://www.imsglobal.org/xsd/imslticm_v1p0',
                                      "xmlns:lticp" => 'http://www.imsglobal.org/xsd/imslticp_v1p0',
                                      "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
                                      "xsi:schemaLocation" => "http://www.imsglobal.org/xsd/imslticc_v1p0 http://www.imsglobal.org/xsd/lti/ltiv1p0/imslticc_v1p0.xsd http://www.imsglobal.org/xsd/imsbasiclti_v1p0 http://www.imsglobal.org/xsd/lti/ltiv1p0/imsbasiclti_v1p0p1.xsd http://www.imsglobal.org/xsd/imslticm_v1p0 http://www.imsglobal.org/xsd/lti/ltiv1p0/imslticm_v1p0.xsd http://www.imsglobal.org/xsd/imslticp_v1p0 http://www.imsglobal.org/xsd/lti/ltiv1p0/imslticp_v1p0.xsd"
      ) do |blti_node|
        
        %w{title description launch_url secure_launch_url}.each do |key|
          blti_node.blti key.to_sym, self.send(key) if self.send(key)
        end
        
        vendor_keys = %w{name code description url}
        if vendor_keys.any?{|k|self.send("vendor_#{k}")} || vendor_contact_email
          blti_node.blti :vendor do |v_node|
            vendor_keys.each do |key|
              v_node.lticp key.to_sym, self.send("vendor_#{key}") if self.send("vendor_#{key}")
            end
            if vendor_contact_email
              v_node.lticp :contact do |c_node|
                c_node.lticp :email, vendor_contact_email
              end
            end
          end
        end

        if !@custom_params.empty?
          blti_node.tag!("blti:custom") do |custom_node|
            @custom_params.each_pair do |key, val|
              custom_node.lticm :property, val, 'name' => key
            end
          end
        end
        
        if !@extensions.empty?
          @extensions.each_pair do |ext_platform, ext_params|
            blti_node.blti(:extensions, :platform => ext_platform) do |ext_node|
              ext_params.each_pair do |key, val|
                if val.is_a?(Hash)
                  ext_node.lticm(:options, :name => key) do |type_node|
                    val.each_pair do |p_key, p_val|
                      type_node.lticm :property, p_val, 'name' => p_key
                    end
                  end
                else
                  ext_node.lticm :property, val, 'name' => key
                end
              end
            end
          end
        end
        
      end
    end

  end
end
