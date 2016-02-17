require 'spec_helper'

module IMS::LTI::Models::MembershipService
  describe Membership do
    it 'includes IMS::LTI::Models::Serializable' do
      includes = Membership.ancestors.select { |o| o.class == Module }
      expect(includes.include?(IMS::LTI::Models::Serializable)).to eq true
    end

    describe '#initialize' do
      it 'initializes properly' do
        membership = Membership.new({
          id: 1,
          status: 2,
          member: 3,
          role: 4
        })
        expect(membership.id).to eq 1
        expect(membership.status).to eq 2
        expect(membership.member).to eq 3
        expect(membership.role).to eq 4
      end
    end
  end
end
