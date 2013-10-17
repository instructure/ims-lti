require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')

describe IMS::LTI::Extensions do
  subject(:tc) do
    tc = IMS::LTI::ToolConfig.new("title" => "Test Config", "secure_launch_url" => "https://www.example.com/lti", "custom_params" => {"custom1" => "customval1"})
    tc.extend IMS::LTI::Extensions::Canvas::ToolConfig
  end

  it "should support default canvas extension parameters" do
    tc.canvas_privacy_public!
    tc.canvas_domain! 'www.google.com'
    tc.canvas_text! 'Test Tool'
    tc.canvas_icon_url! 'http://example.com/icon.ico'
    tc.canvas_selector_dimensions! 500, 400
    tc.canvas_tool_id! 'tool_id'

    tc.get_canvas_param(:privacy_level).should == 'public'
    tc.get_canvas_param(:domain).should == 'www.google.com'
    tc.get_canvas_param(:text).should == 'Test Tool'
    tc.get_canvas_param(:icon_url).should == 'http://example.com/icon.ico'
    tc.get_canvas_param(:selection_width).should == 500
    tc.get_canvas_param(:selection_height).should == 400
    tc.get_canvas_param(:tool_id).should == 'tool_id'
  end

  it "should support canvas extensions" do
    params = {:url => 'http://example.com/launch'}

    tc.canvas_homework_submission!({:url => 'http://example.com/homework'})
    tc.canvas_editor_button!({:url => 'http://example.com/editor'})
    tc.canvas_resource_selection!({:url => 'http://example.com/resource'})
    tc.canvas_account_navigation!({:url => 'http://example.com/account'})
    tc.canvas_course_navigation!({:url => 'http://example.com/course'})
    tc.canvas_user_navigation!({:url => 'http://example.com/user'})

    tc.get_canvas_param(:homework_submission).should == {:url => 'http://example.com/homework'}
    tc.get_canvas_param(:editor_button).should == {:url => 'http://example.com/editor'}
    tc.get_canvas_param(:resource_selection).should == {:url => 'http://example.com/resource'}
    tc.get_canvas_param(:account_navigation).should == {:url => 'http://example.com/account'}
    tc.get_canvas_param(:course_navigation).should == {:url => 'http://example.com/course'}
    tc.get_canvas_param(:user_navigation).should == {:url => 'http://example.com/user'}
  end
end