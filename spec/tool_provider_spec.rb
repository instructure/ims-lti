require "spec_helper"
describe IMS::LTI::ToolProvider do
  #todo test stuff from certification: http://www.imsglobal.org/developers/alliance/LTI/cert-v1p1/
  before do
    @params = {
            "lti_message_type" => "basic-lti-launch-request",
            "lti_version" => "LTI-1p0",
            "resource_link_id" => "c28ddcf1b2b13c52757aed1fe9b2eb0a4e2710a3",
            "lis_result_sourcedid" => "261-154-728-17-7846bbb43e6551d8c896d30c1676dce0184579f0",
            "lis_outcome_service_url" =>"http://localhost/lis_grade_passback",
            "custom_param1" => "custom1",
            "custom_param2" => "custom2",
            "ext_lti_message_type" => "extension-lti-launch"
    }
    
    @tp = IMS::LTI::ToolProvider.new("hi", 'oi', @params)
  end
  
  it "should process parameters" do
    @params.each_pair do |key, val|
      @tp.send(key).should == val unless key =~ /custom_|ext_/
    end
    
    @tp.to_params.should == @params
  end
  
  it "should check for launch request" do
    @tp.launch_request?.should == true
    @tp.lti_message_type = "different"
    @tp.launch_request?.should == false
  end
  
  it "should handle custom/extension parameters" do
    @tp.get_custom_param('param1').should == 'custom1'
    @tp.get_custom_param('param2').should == 'custom2'
    @tp.get_ext_param('lti_message_type').should == 'extension-lti-launch'
    
    @tp.set_custom_param("param3", "custom3")
    @tp.set_ext_param("user_id", "bob")
    
    params = @tp.to_params
    params["custom_param1"].should == 'custom1'
    params["custom_param2"].should == 'custom2'
    params["custom_param3"].should == 'custom3'
    params["ext_lti_message_type"].should == "extension-lti-launch"
    params["ext_user_id"].should == "bob"
  end
  
  it "should not accept invalid request" do
    request = Net::HTTP::Post.new('/test?key=value')
    
    @tp.valid_request?(request).should == false
  end
  
  context "outcome results" do
     response_xml = <<-XML
      <?xml version="1.0" encoding="UTF-8"?>
      <imsx_POXEnvelopeResponse xmlns="http://www.imsglobal.org/lis/oms1p0/pox">
        <imsx_POXHeader>
          <imsx_POXResponseHeaderInfo>
            <imsx_version>V1.0</imsx_version>
            <imsx_messageIdentifier/>
            <imsx_statusInfo>
              <imsx_codeMajor>success</imsx_codeMajor>
              <imsx_severity>status</imsx_severity>
              <imsx_description></imsx_description>
              <imsx_messageRefIdentifier>123456789</imsx_messageRefIdentifier> 
              <imsx_operationRefIdentifier>replaceResult</imsx_operationRefIdentifier> 
            </imsx_statusInfo>
          </imsx_POXResponseHeaderInfo>
        </imsx_POXHeader>
        <imsx_POXBody><replaceResultResponse/></imsx_POXBody>
      </imsx_POXEnvelopeResponse>
    XML
    
    expected_xml = %{<?xml version="1.0" encoding="UTF-8"?><imsx_POXEnvelopeRequest xmlns="http://www.imsglobal.org/lis/oms1p0/pox"><imsx_POXHeader><imsx_POXRequestHeaderInfo><imsx_version>V1.0</imsx_version><imsx_messageIdentifier>123456789</imsx_messageIdentifier></imsx_POXRequestHeaderInfo></imsx_POXHeader><imsx_POXBody><replaceResultRequest><resultRecord><sourcedGUID><sourcedId>261-154-728-17-7846bbb43e6551d8c896d30c1676dce0184579f0</sourcedId></sourcedGUID><result><resultScore><language>en</language><textString>5</textString></resultScore></result></resultRecord></replaceResultRequest></imsx_POXBody></imsx_POXEnvelopeRequest>}
    
    it "should recognize an outcome request" do
      @tp.outcome_service?.should == true
      @tp.lis_result_sourcedid = nil
      @tp.outcome_service?.should == false
    end
    
    it "should generate correct outcome result xml" do
      @tp.generate_outcome_xml(5).should == expected_xml
    end
    
    it "should post the results" do
      fake = Object
      OAuth::AccessToken.stub(:new).and_return(fake)
      fake.should_receive(:post).with(@params['lis_outcome_service_url'], expected_xml, {'Content-Type' => 'application/xml'})
      @tp.post_outcome(5)
    end
    
    it "should recognize a success response" do
      fake = Object
      fake.stub(:code).and_return("200")
      fake.stub(:body).and_return(response_xml)
      @tp.outcome_response = fake
      
      @tp.outcome_post_successful?.should == true
    end
    
    it "should recognize a failure response" do
      fake = Object
      fake.stub(:code).and_return("200")
      fake.stub(:body).and_return(response_xml.gsub('success', 'failure'))
      @tp.outcome_response = fake
      @tp.outcome_post_successful?.should == false
    end
    
  end

end
