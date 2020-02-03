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
    @tp.accepts_submitted_at?.should == false
    @tp.accepts_outcome_lti_launch_url?.should == false
  end

  it "should add TC functionality" do
    tc = IMS::LTI::ToolConsumer.new("hey", "ho")
    tc.extend IMS::LTI::Extensions::OutcomeData::ToolConsumer
    tc.support_outcome_data!
    tc.outcome_data_values_accepted.should == 'text,url,lti_launch_url,submitted_at'
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

  it "should generate an extended outcome text request using cdata" do
    xml = result_xml % %{<resultScore><language>en</language><textString>.5</textString></resultScore><resultData><text><![CDATA[the text]]></text></resultData>}
    mock_request(xml)

    @tp.post_replace_result_with_data!('.5', "cdata_text" => "the text")
  end

  it "should generate an extended outcome url request" do
    xml = result_xml % %{<resultData><url>http://www.example.com</url></resultData>}
    mock_request(xml)

    @tp.post_replace_result_with_data!(nil, "url" => "http://www.example.com")
  end

  it "should generate an extended outcome url request" do
    xml = result_xml % %{<resultData><ltiLaunchUrl>http://www.example.com/launch</ltiLaunchUrl></resultData>}
    mock_request(xml)

    @tp.post_replace_result_with_data!(nil, "lti_launch_url" => "http://www.example.com/launch")
  end

  it "should parse replaceResult xml with extension val for url" do
    req = IMS::LTI::OutcomeRequest.new
    req.extend IMS::LTI::Extensions::OutcomeData::OutcomeRequest
    req.process_xml(result_xml % %{<resultData><url>http://www.example.com</url></resultData>})
    req.outcome_url.should == "http://www.example.com"
  end

  it "should parse replaceResult xml with extension val for ltiLaunchUrl" do
    req = IMS::LTI::OutcomeRequest.new
    req.extend IMS::LTI::Extensions::OutcomeData::OutcomeRequest
    req.process_xml(result_xml % %{<resultData><ltiLaunchUrl>http://www.example.com/launch</ltiLaunchUrl></resultData>})
    req.outcome_lti_launch_url.should == "http://www.example.com/launch"
  end

  it "should parse replaceResult xml with extension val for text" do
    req = IMS::LTI::OutcomeRequest.new
    req.extend IMS::LTI::Extensions::OutcomeData::OutcomeRequest
    req.process_xml(result_xml % %{<resultData><text>what the text</text></resultData>})
    req.outcome_text.should == "what the text"
  end

  describe 'OutcomeData::ToolProvider' do
    describe '#generate_request_xml' do
      it 'handles cdata_text' do
        xml = result_xml % %{<resultData><text><![CDATA[my cdata]]></text></resultData>}
        mock_request(xml)

        @tp.post_extended_replace_result!(cdata_text: 'my cdata')
      end

      it 'handles text' do
        xml = result_xml % %{<resultData><text>my text</text></resultData>}
        mock_request(xml)

        @tp.post_extended_replace_result!(text: 'my text')
      end

      it 'handles url' do
        xml = result_xml % %{<resultData><url>http://url</url></resultData>}
        mock_request(xml)

        @tp.post_extended_replace_result!(url: 'http://url')
      end

      it 'handles submitted_at' do
        xml = submission_xml % %{<submittedAt>2020-01-01</submittedAt>}
        mock_request(xml)

        @tp.post_extended_replace_result!(submitted_at: '2020-01-01')
      end

      it 'handles total_score' do
        xml = result_xml % %{<resultTotalScore><language>en</language><textString>13</textString></resultTotalScore>}
        mock_request(xml)

        @tp.post_extended_replace_result!(total_score: '13')
      end

      it 'handles score' do
        xml = result_xml % %{<resultScore><language>en</language><textString>.7</textString></resultScore>}
        mock_request(xml)

        @tp.post_extended_replace_result!(score: '.7')
      end

      it 'handles lti_launch_url' do
        xml = result_xml % %{<resultData><ltiLaunchUrl>http://url/launch</ltiLaunchUrl></resultData>}
        mock_request(xml)

        @tp.post_extended_replace_result!(lti_launch_url: 'http://url/launch')
      end

      it 'handles all options at once' do
        xml = result_xml % %{<resultTotalScore><language>en</language><textString>13</textString></resultTotalScore><resultData><text><![CDATA[my cdata]]></text><url>http://url</url></resultData>}
        mock_request(xml)

        @tp.post_extended_replace_result!(
          'cdata_text' => 'my cdata',
          'text' => 'my text',
          'url' => 'http://url',
          'total_score' => '13',
          'score' => '.7',
          'lti_launch_url' => 'http://url/launch'
        )
      end
    end
  end
end
