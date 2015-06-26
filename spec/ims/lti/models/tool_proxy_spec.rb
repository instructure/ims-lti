require 'spec_helper'
module IMS::LTI::Models
  describe ToolProxy do
    describe "#new" do
      it "provides default values" do
        expect(subject.context).to eq ['http://purl.imsglobal.org/ctx/lti/v2/ToolProxy']
        expect(subject.type).to eq 'ToolProxy'
      end
    end

    it 'pluralizes enabled_capability' do
      expect(subject.enabled_capabilities).to eq []
    end

  end
end