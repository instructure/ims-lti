require "spec_helper"
describe IMS::LTI::ToolProvider do
  #todo test stuff from certification: http://www.imsglobal.org/developers/alliance/LTI/cert-v1p1/
  before do
    create_test_tp
  end

  it "should process parameters" do
    @params.each_pair do |key, val|
      @tp.send(key).should == val unless key =~ /custom_|ext_|roles/
    end
    @tp.roles.should == %w{learner instructor observer}

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

  it "should generate a return url with messages" do
    @tp.build_return_url.should == @params['launch_presentation_return_url']
    @tp.lti_errormsg = "user error message"
    @tp.lti_errorlog = "lms error log"
    @tp.lti_msg = "user message"
    @tp.lti_log = "lms message"
    @tp.build_return_url.should == @params['launch_presentation_return_url'] + "?lti_errormsg=user%20error%20message&lti_errorlog=lms%20error%20log&lti_msg=user%20message&lti_log=lms%20message"
  end

  it "should recognize the roles" do
    @tp.student?.should == true
    @tp.instructor?.should == true
    @tp.has_role?('Observer').should == true
    @tp.has_role?('administrator').should == false
  end

  it "should find the best username" do
    @tp.username("guy").should == "guy"
    @tp.lis_person_name_full = "full"
    @tp.username("guy").should == "full"
    @tp.lis_person_name_family = "family"
    @tp.username("guy").should == "family"
    @tp.lis_person_name_given = "given"
    @tp.username("guy").should == "given"
  end

end
