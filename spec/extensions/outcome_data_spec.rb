require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')

describe IMS::LTI::Extensions do
  before do
    create_params
    @params['ext_outcome_data_values_accepted'] = 'text'
    @tp = IMS::LTI::ToolProvider.new("hi", 'oi', @params)
    @tp.extend IMS::LTI::Extensions::OutcomeData::ToolProvider
  end

  it "should correctly check supported data fields" do
    @tp.accepts_outcome_data?.should == true
    @tp.accepts_outcome_text?.should == true
    @tp.accepts_outcome_url?.should == false
  end
  
  it "should add TC functionality" do
    tc = IMS::LTI::ToolConsumer.new("hey", "ho")
    tc.extend IMS::LTI::Extensions::OutcomeData::ToolConsumer
    tc.support_outcome_data!
    tc.outcome_data_values_accepted.should == 'text,url'
    tc.outcome_data_values_accepted = 'url,text'
    tc.outcome_data_values_accepted.should == 'url,text'
    tc.outcome_data_values_accepted = %w{text url}
    tc.outcome_data_values_accepted.should == 'text,url'
    tc.to_params['ext_outcome_data_values_accepted'].should == 'text,url'
  end

  it "should generate an extended outcome text request" do
    xml = result_xml % %{<resultScore><language>en</language><textString>.5</textString></resultScore><resultData><text>the text</text></resultData>}
    mock_request(xml)
    
    @tp.post_replace_result_with_data!('.5', "text" => "the text")
  end

  it "should generate an extended outcome url request" do
    xml = result_xml % %{<resultData><url>http://www.example.com</url></resultData>}
    mock_request(xml)
    
    @tp.post_replace_result_with_data!(nil, "url" => "http://www.example.com")
  end
  
  it "should parse replaceResult xml with extension val" do
    req = IMS::LTI::OutcomeRequest.new
    req.extend IMS::LTI::Extensions::OutcomeData::OutcomeRequest
    req.process_xml(result_xml % %{<resultData><url>http://www.example.com</url></resultData>})
    req.outcome_url.should == "http://www.example.com"
  end
  
  it "should parse replaceResult xml with extension val" do
    req = IMS::LTI::OutcomeRequest.new
    req.extend IMS::LTI::Extensions::OutcomeData::OutcomeRequest
    req.process_xml(result_xml % %{<resultData><text>what the text</text></resultData>})
    req.outcome_text.should == "what the text"
  end
  
  it "should parse replaceResult xml with extension val" do
    req = IMS::LTI::OutcomeRequest.new
    req.extend IMS::LTI::Extensions::OutcomeData::OutcomeRequest
    req.process_xml(result_xml % %{<resultData><text>what the text</text></resultData>})
    req.outcome_text.should == "what the text"
  end
end