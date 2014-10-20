require "spec_helper"
describe IMS::LTI::OutcomeResponse do

  response_xml = <<-XML
<?xml version="1.0" encoding="UTF-8"?>
<imsx_POXEnvelopeResponse xmlns="http://www.imsglobal.org/services/ltiv1p1/xsd/imsoms_v1p0">
<imsx_POXHeader>
<imsx_POXResponseHeaderInfo>
<imsx_version>V1.0</imsx_version>
<imsx_messageIdentifier></imsx_messageIdentifier>
<imsx_statusInfo>
<imsx_codeMajor>success</imsx_codeMajor>
<imsx_severity>status</imsx_severity>
<imsx_description/>
<imsx_messageRefIdentifier>123456789</imsx_messageRefIdentifier>
<imsx_operationRefIdentifier>replaceResult</imsx_operationRefIdentifier>
</imsx_statusInfo>
</imsx_POXResponseHeaderInfo>
</imsx_POXHeader>
<imsx_POXBody>
<replaceResultResponse/>
</imsx_POXBody>
</imsx_POXEnvelopeResponse>
  XML

  def mock_response(xml)
    @fake = Object
    OAuth::AccessToken.stub(:new).and_return(@fake)
    @fake.should_receive(:code).and_return("200")
    @fake.stub(:body).and_return(xml)
  end

  it "should parse replaceResult response xml" do
    mock_response(response_xml)
    res = IMS::LTI::OutcomeResponse.from_post_response(@fake)
    res.success?.should == true
    res.code_major.should == 'success'
    res.severity.should == 'status'
    res.description.should == nil
    res.message_ref_identifier.should == '123456789'
    res.operation.should == 'replaceResult'
    res.score.should == nil
  end

  it "should parse readResult response xml" do
    read_xml = response_xml.gsub('<replaceResultResponse/>', <<-XML)
<readResultResponse>
<result>
<resultScore>
<language>en</language>
<textString>0.91</textString>
</resultScore>
</result>
</readResultResponse>
    XML
    read_xml.gsub!('replaceResult', 'readResult')
    mock_response(read_xml)
    res = IMS::LTI::OutcomeResponse.from_post_response(@fake)
    res.success?.should == true
    res.code_major.should == 'success'
    res.severity.should == 'status'
    res.description.should == nil
    res.message_ref_identifier.should == '123456789'
    res.operation.should == 'readResult'
    res.score.should == '0.91'
  end

  it "should parse readResult response xml" do
    mock_response(response_xml.gsub('replaceResult', 'deleteResult'))
    res = IMS::LTI::OutcomeResponse.from_post_response(@fake)
    res.success?.should == true
    res.code_major.should == 'success'
    res.severity.should == 'status'
    res.description.should == nil
    res.message_ref_identifier.should == '123456789'
    res.operation.should == 'deleteResult'
    res.score.should == nil
  end

  it "should recognize a failure response" do
    mock_response(response_xml.gsub('success', 'failure'))
    res = IMS::LTI::OutcomeResponse.from_post_response(@fake)
    res.failure?.should == true
  end

  it "should generate response xml" do
    res = IMS::LTI::OutcomeResponse.new
    res.process_xml(response_xml)
    alt = response_xml.gsub("\n",'')
    res.generate_response_xml.should == alt
  end

end
