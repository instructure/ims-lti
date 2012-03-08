require "spec_helper"
describe IMS::LTI::OutcomeRequest do
  before do
    create_test_tp
  end

  def mock_request(expected_xml)
    IMS::LTI.stub(:generate_identifier).and_return("123456789")
    @fake = Object
    OAuth::AccessToken.stub(:new).and_return(@fake)
    @fake.should_receive(:code).and_return("200")
    @fake.stub(:body).and_return("<xml/>")
    @fake.should_receive(:post).with(@params['lis_outcome_service_url'], expected_xml, {'Content-Type' => 'application/xml'}).and_return(@fake)
  end

  expected_xml = %{<?xml version="1.0" encoding="UTF-8"?><imsx_POXEnvelopeRequest xmlns="http://www.imsglobal.org/lis/oms1p0/pox"><imsx_POXHeader><imsx_POXRequestHeaderInfo><imsx_version>V1.0</imsx_version><imsx_messageIdentifier>123456789</imsx_messageIdentifier></imsx_POXRequestHeaderInfo></imsx_POXHeader><imsx_POXBody>%s</imsx_POXBody></imsx_POXEnvelopeRequest>}
  replace_result_xml = expected_xml % %{<replaceResultRequest><resultRecord><sourcedGUID><sourcedId>261-154-728-17-784</sourcedId></sourcedGUID><result><resultScore><language>en</language><textString>5</textString></resultScore></result></resultRecord></replaceResultRequest>}
  read_result_xml = expected_xml % %{<readResultRequest><resultRecord><sourcedGUID><sourcedId>261-154-728-17-784</sourcedId></sourcedGUID></resultRecord></readResultRequest>}
  delete_result_xml = expected_xml % %{<deleteResultRequest><resultRecord><sourcedGUID><sourcedId>261-154-728-17-784</sourcedId></sourcedGUID></resultRecord></deleteResultRequest>}

  it "should post the replaceResult request" do
    mock_request(replace_result_xml)
    @tp.post_replace_result!(5)
    @tp.last_outcome_success?.should == false
  end

  it "should post readResult request" do
    mock_request(read_result_xml)
    @tp.post_read_result!
  end

  it "should post deleteResult request" do
    mock_request(delete_result_xml)
    @tp.post_delete_result!
  end

  it "should parse replaceResult xml" do
    req = IMS::LTI::OutcomeRequest.new
    req.process_xml(replace_result_xml)
    req.operation.should == 'replaceResult'
    req.lis_result_sourcedid.should == '261-154-728-17-784'
    req.message_identifier.should == '123456789'
    req.score.should == '5'
  end

  it "should parse readResult xml" do
    req = IMS::LTI::OutcomeRequest.new
    req.process_xml(read_result_xml)
    req.operation.should == 'readResult'
    req.lis_result_sourcedid.should == '261-154-728-17-784'
    req.message_identifier.should == '123456789'
    req.score.should == nil
  end

  it "should parse deleteResult xml" do
    req = IMS::LTI::OutcomeRequest.new
    req.process_xml(delete_result_xml)
    req.operation.should == 'deleteResult'
    req.lis_result_sourcedid.should == '261-154-728-17-784'
    req.message_identifier.should == '123456789'
    req.score.should == nil
  end

end
