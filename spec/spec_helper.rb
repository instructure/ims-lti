lib_dir = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'rspec'
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
            "invalid_ext_param" => "invalid_param",
            "invalid_custom_param" => "invalid_custom",
            "ext_lti_message_type" => "extension-lti-launch",
            "roles" => "Learner,Instructor,Observer,urn:lti:role:ims/lis/Member,Mentor/Mentor,Administrator,urn:lti:role:ims/lis/TeachingAssistant/TeachingAssistantSection"
    }
end

def valid_params
  @params.reject {|p| p =~ /\Ainvalid_.+\Z/ }
end

def create_test_tp
  create_params
  @tp = IMS::LTI::ToolProvider.new("hi", 'oi', @params)
end

def expected_xml; %{<?xml version="1.0" encoding="UTF-8"?><imsx_POXEnvelopeRequest xmlns="http://www.imsglobal.org/services/ltiv1p1/xsd/imsoms_v1p0"><imsx_POXHeader><imsx_POXRequestHeaderInfo><imsx_version>V1.0</imsx_version><imsx_messageIdentifier>123456789</imsx_messageIdentifier></imsx_POXRequestHeaderInfo></imsx_POXHeader><imsx_POXBody>%s</imsx_POXBody></imsx_POXEnvelopeRequest>} end
def result_base_xml; expected_xml % %{<replaceResultRequest><resultRecord><sourcedGUID><sourcedId>261-154-728-17-784</sourcedId></sourcedGUID>%s</resultRecord>%s</replaceResultRequest>} end
def result_xml; result_base_xml % %{<result>%s</result>} %{} end
def submission_xml; result_base_xml % %{} %{<submissionDetails>%s</submissionDetails>} end
def replace_result_xml; result_xml % %{<resultScore><language>en</language><textString>5</textString></resultScore>} end
def read_result_xml; expected_xml % %{<readResultRequest><resultRecord><sourcedGUID><sourcedId>261-154-728-17-784</sourcedId></sourcedGUID></resultRecord></readResultRequest>} end
def delete_result_xml; expected_xml % %{<deleteResultRequest><resultRecord><sourcedGUID><sourcedId>261-154-728-17-784</sourcedId></sourcedGUID></resultRecord></deleteResultRequest>} end

def mock_request(expected_xml)
  IMS::LTI.stub(:generate_identifier).and_return("123456789")
  @fake = Object
  OAuth::AccessToken.stub(:new).and_return(@fake)
  @fake.should_receive(:code).and_return("200")
  @fake.stub(:body).and_return("<xml/>")
  @fake.should_receive(:post).with(@params['lis_outcome_service_url'], expected_xml, {'Content-Type' => 'application/xml'}).and_return(@fake)
end
