module IMS::LTI
  class ToolProvider
    # Launch data is described here: http://www.imsglobal.org/lti/v1p1pd/ltiIMGv1p1pd.html#_Toc309649684
    LAUNCH_DATA_PARAMETERS = %w{
      lti_message_type 
      lti_version
      resource_link_id
      resource_link_title
      user_id
      roles
      lis_result_sourcedid
      lis_outcome_service_url
      lis_person_name_given
      lis_person_name_family
      lis_person_name_full
      lis_person_contact_email_primary
      context_id
      context_type
      context_title
      context_label
      launch_presentation_locale
      launch_presentation_document_target
      launch_presentation_width
      launch_presentation_height
      launch_presentation_return_url
      tool_consumer_info_product_family_code
      tool_consumer_info_version
      tool_consumer_instance_guid
      tool_consumer_instance_name
      tool_consumer_instance_contact_email
      resource_link_description
      user_image
      launch_presentation_css_url
      tool_consumer_instance_description
      tool_consumer_instance_url
      lis_person_sourcedid
      lis_course_offering_sourcedid
      lis_course_section_sourcedid
    }
    LAUNCH_DATA_PARAMETERS.each{|p|attr_accessor p}
    
    attr_accessor :consumer_key, :consumer_secret, :lti_params, :custom_params, :ext_params, :outcome_response
    
    def initialize(consumer_key, consumer_secret, params={})
      @consumer_key = consumer_key
      @consumer_secret = consumer_secret
      @custom_params = {}
      @ext_params = {}
      process_params(params)
    end
    
    def valid_request?(request, handle_error=true)
      begin
        signature = OAuth::Signature.build(request, :consumer_secret => @consumer_secret)
        signature.verify() or raise OAuth::Unauthorized
        true
      rescue OAuth::Signature::UnknownSignatureMethod, OAuth::Unauthorized
        if handle_error
          false
        else
          raise $!
        end
      end
    end
    
    def valid_request!(request)
      valid_request?(request, false)
    end
    
    def launch_request?
      lti_message_type == 'basic-lti-launch-request'
    end
    
    def outcome_service?
      !!(lis_outcome_service_url && lis_result_sourcedid)
    end
    
    def username
      lis_person_name_full || lis_person_name_given || lis_person_name_family 
    end
    
    def set_custom_param(key, val)
      @custom_params[key] = val
    end
    
    def get_custom_param(key)
      @custom_params[key]
    end
    
    def set_ext_param(key, val)
      @ext_params[key] = val
    end
    
    def get_ext_param(key)
      @ext_params[key]
    end
    
    # Posts the given score to the Tool Consumer with a replaceResult
    def post_replace_result!(score)
      post_outcome_request(generate_outcome_xml('replaceResultRequest', score))
    end
    
    def post_delete_result!
      post_outcome_request(generate_outcome_xml('deleteResultRequest'))
    end
    
    def post_read_result!
      post_outcome_request(generate_outcome_xml('readResultRequest'))
    end
    
    def outcome_post_successful?
      #todo parse and handle responses as described: http://www.imsglobal.org/gws/gwsv1p0/imsgws_baseProfv1p0.html#1639667
      !!(@outcome_response.code == '200' && @outcome_response.body.match(/\bsuccess\b/))
    end
    
    def launch_data_hash
      LAUNCH_DATA_PARAMETERS.inject({}){|h,k|h[k] = self.send(k) if self.send(k); h}
    end
    
    def to_params
      launch_data_hash.merge(add_key_prefix(@custom_params, 'custom')).merge(add_key_prefix(@ext_params, 'ext'))
    end
    
    private
    
    def post_outcome_request(xml)
      consumer = OAuth::Consumer.new(@consumer_key, @consumer_secret)
      token = OAuth::AccessToken.new(consumer)
      @outcome_response = token.post(
              lis_outcome_service_url, 
              xml, 
              'Content-Type' => 'application/xml'
      )
    end

    def generate_outcome_xml(request_type, score=nil)
      builder = Builder::XmlMarkup.new #(:indent=>2)
      builder.instruct!

      builder.imsx_POXEnvelopeRequest("xmlns" => "http://www.imsglobal.org/lis/oms1p0/pox") do |env|
        env.imsx_POXHeader do |header|
          header.imsx_POXRequestHeaderInfo do |info|
            info.imsx_version "V1.0"
            info.imsx_messageIdentifier "123456789" #todo real identifier
          end
        end
        env.imsx_POXBody do |body|
          body.tag!(request_type) do |request|
            request.resultRecord do |record|
              record.sourcedGUID do |guid|
                guid.sourcedId lis_result_sourcedid
              end
              if score
                record.result do |res|
                  res.resultScore do |res_score|
                    res_score.language "en" # 'en' represents the format of the number
                    res_score.textString score.to_s
                  end
                end
              end
            end
          end
        end
      end
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
      hash.keys.inject({}){|h, k| h["#{prefix}_#{k}"] = hash[k];h}
    end
    
  end
end
