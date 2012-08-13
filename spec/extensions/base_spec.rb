require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')

module TestLTIExtension
  module Base
    def outcome_request_extensions
      super + [TestLTIExtension::OutcomeRequest]
    end
    def outcome_response_extensions
      super + [TestLTIExtension::OutcomeResponse]
    end
  end

  module ToolProvider
    include IMS::LTI::Extensions::ExtensionBase
    include Base
    
    def tp_test
      'hey'
    end
  end

  module ToolConsumer
    include IMS::LTI::Extensions::ExtensionBase
    include Base
    
    def special_key=(val)
      set_ext_param('special_key', val)
    end
    
    def special_key
      get_ext_param('special_key')
    end
  end

  module OutcomeRequest
    include IMS::LTI::Extensions::ExtensionBase
    include Base
    
    attr_accessor :test_val

    def request_test
      'hey there'
    end
    
    def extention_process_xml(doc)
      super
      @test_val = doc.get_text("//resultRecord/result/testVal")
    end
  end

  module OutcomeResponse
    include IMS::LTI::Extensions::ExtensionBase
    include Base

    def response_test
      'oh hey there'
    end
  end
end

describe IMS::LTI::Extensions do
  before do
    create_test_tp
    @tp.extend TestLTIExtension::ToolProvider
  end
  
  it "should add TP functionality" do
    @tp.tp_test.should == 'hey'
  end
  
  it "should add TC functionality" do
    tc = IMS::LTI::ToolConsumer.new("hey", "ho")
    tc.extend TestLTIExtension::ToolConsumer
    tc.special_key = 'hey'
    tc.special_key.should == 'hey'
    tc.to_params['ext_special_key'].should == 'hey'
  end
  
  it "should generate an extended outcome request" do
    mock_request(replace_result_xml)
    @tp.post_replace_result!(5)
    @tp.last_outcome_request.request_test.should == 'hey there'
  end
  
  it "should parse replaceResult xml with extension val" do
    req = IMS::LTI::OutcomeRequest.new
    req.extend TestLTIExtension::OutcomeRequest
    req.process_xml(result_xml % %{<testVal>hey there</testVal>})
    req.test_val.should == 'hey there'
  end
  
  it "should generate an extended outcome response" do
    mock_request(replace_result_xml)
    @tp.post_replace_result!(5)
    @tp.last_outcome_request.outcome_response.response_test.should == 'oh hey there'
  end
end

