require "spec_helper"
describe IMS::LTI::RequestValidator do
  context "invalid request" do
    let(:oauth_signature_validator) { double("oauth_signature_validator") }
    before do
      create_params
      @tool = IMS::LTI::ToolProvider.new("hooi", 'oi', @params)
    end

    it "should raise OAuth::Unauthorized" do
      request = Net::HTTP::Post.new('/test?key=value')
      allow(OAuth::Signature).to receive(:build).and_return(oauth_signature_validator)
      allow(oauth_signature_validator).to receive(:verify).and_return(false)
      expect do
        @tool.valid_request?(request, false)
      end.to raise_error(OAuth::Unauthorized)
    end
  end
end
