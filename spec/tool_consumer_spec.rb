require "spec_helper"
describe IMS::LTI::ToolConsumer do
  def create_tc
    # This is the example in the docs at: http://www.imsglobal.org/LTI/v1p1pd/ltiIMGv1p1pd.html#_Toc309649707
    @tc = IMS::LTI::ToolConsumer.new('12345', 'secret')
    @tc.launch_url = 'http://dr-chuck.com/ims/php-simple/tool.php'
    @tc.timestamp = '1251600739'
    @tc.nonce = 'c8350c0e47782d16d2fa48b2090c1d8f'

    @tc.resource_link_id = '120988f929-274612'
    @tc.user_id = '292832126'
    @tc.roles = 'Instructor'
    @tc.lis_person_name_full = 'Jane Q. Public'
    @tc.lis_person_contact_email_primary = 'user@school.edu'
    @tc.set_non_spec_param('lis_person_sourced_id', 'school.edu:user')
    @tc.context_id = '456434513'
    @tc.context_title = 'Design of Personal Environments'
    @tc.context_label = 'SI182'
    @tc.lti_version = 'LTI-1p0'
    @tc.lti_message_type = 'basic-lti-launch-request'
    @tc.tool_consumer_instance_guid = 'lmsng.school.edu'
    @tc.tool_consumer_instance_description = 'University of School (LMSng)'
    @tc.set_non_spec_param('basiclti_submit', 'Launch Endpoint with BasicLTI Data')
  end

  it "should generate a correct signature" do
    create_tc
    res = @tc.generate_launch_data
    res['oauth_signature'].should eql('Eh+W+ZMn4CB9momDqyJXf5yMfTc=')
  end

  it "should generate a correct signature with URL query parameters" do
    create_tc
    @tc.launch_url = 'http://dr-chuck.com/ims/php-simple/tool.php?a=1&b=2&c=3%20%26a'
    res = @tc.generate_launch_data
    res['oauth_signature'].should eql('iN1kwF7CYLWi0BJCo3G7rlGHTm8=')
    res['c'].should == "3 &a"
  end

  it "should generate a correct signature with a non-standard port" do
    @tc = IMS::LTI::ToolConsumer.new('12345', 'secret', 'resource_link_id' => 1)
    @tc.timestamp = '1251600739'
    @tc.nonce = 'c8350c0e47782d16d2fa48b2090c1d8f'

    def test_url(url, sig)
      @tc.launch_url = url
      @tc.generate_launch_data['oauth_signature'].should eql(sig)
    end

    # signatures generated using http://oauth.googlecode.com/svn/code/javascript/example/signature.html
    # accessed on : 2013-06-24
    test_url('http://dr-chuck.com:123/ims/php-simple/tool.php', 'dG1tuMWpQw2Tg/aM1RLL/+o11rE=')
    test_url('http://dr-chuck.com/ims/php-simple/tool.php', '5/m7IyWjp5mzc98CtyagO4lZj2A=')
    test_url('http://dr-chuck.com:80/ims/php-simple/tool.php', '5/m7IyWjp5mzc98CtyagO4lZj2A=')
    test_url('http://dr-chuck.com:443/ims/php-simple/tool.php', '3UGVtB8kHe3O0A9cW1XSNhYcG/E=')
    test_url('https://dr-chuck.com/ims/php-simple/tool.php', 'ZoR3mXQgkd5JNY6T47CeNdvIgy8=')
    test_url('https://dr-chuck.com:443/ims/php-simple/tool.php', 'ZoR3mXQgkd5JNY6T47CeNdvIgy8=')
    test_url('https://dr-chuck.com:80/ims/php-simple/tool.php', 'dLmHNc5t74KTIr5uqQ85E2O3N9w=')
    test_url('https://dr-chuck.com:80/ims/php-simple/tool.php?oi=hoyt', '3gwTnBk87PzT8GWIJFxvnCxZNmU=')
  end

  it "should include URI query parameters" do
    @tc = IMS::LTI::ToolConsumer.new('12345', 'secret', 'resource_link_id' => 1, 'user_id' => 2)
    @tc.launch_url = 'http://www.yahoo.com?a=1&b=2'
    hash = @tc.generate_launch_data
    hash['a'].should == '1'
    hash['b'].should == '2'
  end

  it "should not allow overwriting other parameters from the URI query string" do
    @tc = IMS::LTI::ToolConsumer.new('12345', 'secret', 'resource_link_id' => 1, 'user_id' => 2)
    @tc.launch_url = 'http://www.yahoo.com?user_id=123&lti_message_type=1234'
    hash = @tc.generate_launch_data
    hash['user_id'].should == '2'
    hash['lti_message_type'].should == 'basic-lti-launch-request'
  end

end
