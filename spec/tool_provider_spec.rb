require "spec_helper"
describe IMS::LTI::ToolProvider do
  #todo test stuff from certification: http://www.imsglobal.org/developers/alliance/LTI/cert-v1p1/
  before do
    create_test_tp
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

  it "should recognize an outcome service" do
    @tp.outcome_service?.should == true
    @tp.lis_result_sourcedid = nil
    @tp.outcome_service?.should == false
  end

end
