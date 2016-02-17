require 'spec_helper'

module IMS::LTI::Models::MembershipService
  describe LISMembershipContainer do
    it 'includes IMS::LTI::Models::Serializable' do
      includes = LISMembershipContainer.ancestors.select { |o| o.class == Module }
      expect(includes.include?(IMS::LTI::Models::Serializable)).to eq true
    end

    describe '#initialize' do
      it 'initializes properly' do
        container = LISMembershipContainer.new({
          id: 1,
          membership_subject: 1
        })
        expect(container.id).to eq 1
        expect(container.membership_subject).to eq 1
        expect(container.membership_predicate).to eq 'http://www.w3.org/ns/org#membership'
        expect(container.type).to eq 'LISMembershipContainer'
        expect(container.context).to eq 'http://purl.imsglobal.org/ctx/lis/v2/MembershipContainer'
      end
    end
  end
end
