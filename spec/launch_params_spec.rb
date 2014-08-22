require "spec_helper"
describe IMS::LTI::LaunchParams do
  [IMS::LTI::ToolConsumer, IMS::LTI::ToolProvider].each do |tool|
    context tool do
      before do
        create_params
        @tool = tool.new("hi", 'oi', @params)
      end

      it "should process parameters" do
        valid_params.each_pair do |key, val|
          @tool.send(key).should == val unless key =~ /\A(?:custom_.+|ext_.+|roles)\Z/
        end
        @tool.roles.should == ["learner", "instructor", "observer", "urn:lti:role:ims/lis/member", "mentor/mentor", "administrator", "urn:lti:role:ims/lis/teachingassistant/teachingassistantsection"]

        @tool.to_params.should == valid_params
      end

      it "should handle custom/extension parameters" do
        @tool.get_custom_param('param1').should == 'custom1'
        @tool.get_custom_param('param2').should == 'custom2'
        @tool.get_ext_param('lti_message_type').should == 'extension-lti-launch'

        @tool.set_custom_param("param3", "custom3")
        @tool.set_ext_param("user_id", "bob")

        params = @tool.to_params
        params["custom_param1"].should == 'custom1'
        params["custom_param2"].should == 'custom2'
        params["custom_param3"].should == 'custom3'
        params["ext_lti_message_type"].should == "extension-lti-launch"
        params["ext_user_id"].should == "bob"
      end

      it "should not accept invalid request" do
        request = Net::HTTP::Post.new('/test?key=value')
        @tool.valid_request?(request).should == false
      end
    end
  end
end
