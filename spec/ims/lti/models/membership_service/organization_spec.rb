require 'spec_helper'

module IMS::LTI::Models::MembershipService
  describe Organization do
    it 'includes IMS::LTI::Models::Serializable' do
      includes = Organization.ancestors.select { |o| o.class == Module }
      expect(includes.include?(IMS::LTI::Models::Serializable)).to eq true
    end

    describe '#initialize' do
      it 'initializes properly' do
        org = Organization.new({
          id: 1,
          membership: 1,
          name: 'My Organization'
        })
        expect(org.id).to eq 1
        expect(org.membership).to eq 1
        expect(org.name).to eq 'My Organization'
        expect(org.type).to eq 'Organization'
      end
    end
  end
end
