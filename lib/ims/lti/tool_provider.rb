module IMS::LTI
  class ToolProvider
    include IMS::LTI::LaunchParams

    attr_accessor :consumer_key, :consumer_secret, :outcome_requests
    attr_accessor :lti_errormsg, :lti_errorlog, :lti_msg, :lti_log
    
    def initialize(consumer_key, consumer_secret, params={})
      @consumer_key = consumer_key
      @consumer_secret = consumer_secret
      @custom_params = {}
      @ext_params = {}
      @non_spec_params = {}
      @outcome_requests = []
      process_params(params)
    end
    
    def valid_request?(request, handle_error=true)
      IMS::LTI.valid_request?(@consumer_secret, request, handle_error)
    end

    def has_role?(role)
      @roles && @roles.member?(role.downcase)
    end

    # Convenience method for checking if the user has 'learner' or 'student' role
    def student?
      has_role?('learner') || has_role?('student')
    end

    # Convenience method for checking if the user has 'instructor' or 'faculty' or 'staff' role
    def instructor?
      has_role?('instructor') || has_role?('faculty') || has_role?('staff')
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

    # Return the full, given, or family name if set
    def username(default=nil)
      lis_person_name_given || lis_person_name_family || lis_person_name_full || default
    end
    
    # Posts the given score to the Tool Consumer with a replaceResult
    def post_replace_result!(score)
      new_request.post_replace_result!(score)
    end
    
    def post_delete_result!
      new_request.post_delete_result!
    end
    
    def post_read_result!
      new_request.post_read_result!
    end
    
    def last_outcome_request
      @outcome_requests.last
    end
    
    def last_outcome_success?
      last_outcome_request && last_outcome_request.outcome_post_successful?
    end

    def build_return_url
      return nil unless launch_presentation_return_url
      messages = []
      %w{lti_errormsg lti_errorlog lti_msg lti_log}.each do |m|
        if message = self.send(m)
          messages << "#{m}=#{URI.escape(message)}"
        end
      end
      q_string = messages.any? ? ("?" + messages.join("&")) : ''
      launch_presentation_return_url + q_string
    end
    
    private
    
    def new_request
      @outcome_requests << OutcomeRequest.new(:consumer_key => @consumer_key, 
                         :consumer_secret => @consumer_secret, 
                         :lis_outcome_service_url => lis_outcome_service_url, 
                         :lis_result_sourcedid =>lis_result_sourcedid)
      @outcome_requests.last
    end
    
  end
end
