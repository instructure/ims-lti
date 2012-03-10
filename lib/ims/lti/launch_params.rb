module IMS::LTI
  module LaunchParams
    # Launch data is described here: http://www.imsglobal.org/lti/v1p1pd/ltiIMGv1p1pd.html#_Toc309649684
    LAUNCH_DATA_PARAMETERS = %w{
      context_id
      context_label
      context_title
      context_type
      launch_presentation_css_url
      launch_presentation_document_target
      launch_presentation_height
      launch_presentation_locale
      launch_presentation_return_url
      launch_presentation_width
      lis_course_offering_sourcedid
      lis_course_section_sourcedid
      lis_outcome_service_url
      lis_person_contact_email_primary
      lis_person_name_family
      lis_person_name_full
      lis_person_name_given
      lis_person_sourcedid
      lis_result_sourcedid
      lti_message_type
      lti_version
      oauth_callback
      oauth_consumer_key
      oauth_nonce
      oauth_signature
      oauth_signature_method
      oauth_timestamp
      oauth_version
      resource_link_description
      resource_link_id
      resource_link_title
      roles
      tool_consumer_info_product_family_code
      tool_consumer_info_version
      tool_consumer_instance_contact_email
      tool_consumer_instance_description
      tool_consumer_instance_guid
      tool_consumer_instance_name
      tool_consumer_instance_url
      user_id
      user_image
    }

    LAUNCH_DATA_PARAMETERS.each { |p| attr_accessor p }
    attr_accessor :custom_params, :ext_params, :non_spec_params

    # Comma separated list of roles as described here: http://www.imsglobal.org/LTI/v1p1pd/ltiIMGv1p1pd.html#_Toc309649700
    def roles=(roles_list)
      if roles_list
        if roles_list.is_a?(Array)
          @roles = roles_list
        else
          @roles = roles_list.split(",").map(&:downcase)
        end
      else
        @roles = nil
      end
    end

    def set_custom_param(key, val)
      @custom_params[key] = val
    end

    def get_custom_param(key)
      @custom_params[key]
    end

    def set_non_spec_param(key, val)
      @non_spec_params[key] = val
    end

    def get_non_spec_param(key)
      @non_spec_params[key]
    end

    def set_ext_param(key, val)
      @ext_params[key] = val
    end

    def get_ext_param(key)
      @ext_params[key]
    end

    def launch_data_hash
      LAUNCH_DATA_PARAMETERS.inject({}) { |h, k| h[k] = self.send(k) if self.send(k); h }
    end

    def to_params
      params = launch_data_hash.merge(add_key_prefix(@custom_params, 'custom')).merge(add_key_prefix(@ext_params, 'ext')).merge(@non_spec_params)
      params["roles"] = @roles.map(&:capitalize).join(",") if @roles
      params
    end

    def process_params(params)
      params.each_pair do |key, val|
        if LAUNCH_DATA_PARAMETERS.member?(key)
          self.send("#{key}=", val)
        elsif key =~ /custom_(.*)/
          @custom_params[$1] = val
        elsif key =~ /ext_(.*)/
          @ext_params[$1] = val
        end
      end
    end

    def add_key_prefix(hash, prefix)
      hash.keys.inject({}) { |h, k| h["#{prefix}_#{k}"] = hash[k]; h }
    end

  end
end
