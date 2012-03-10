lib_dir = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'spec'
require 'net/http'
require 'ims/lti'

def create_params
  @params = {
            "lti_message_type" => "basic-lti-launch-request",
            "lti_version" => "LTI-1p0",
            "resource_link_id" => "c28ddcf1b2b13c52757aed1fe9b2eb0a4e2710a3",
            "lis_result_sourcedid" => "261-154-728-17-784",
            "lis_outcome_service_url" =>"http://localhost/lis_grade_passback",
            "launch_presentation_return_url" => "http://example.com/lti_return",
            "custom_param1" => "custom1",
            "custom_param2" => "custom2",
            "ext_lti_message_type" => "extension-lti-launch",
            "roles" => "Learner,Instructor,Observer"
    }
end

def create_test_tp
  create_params
  @tp = IMS::LTI::ToolProvider.new("hi", 'oi', @params)
end