require 'spec_helper'

module IMS::LTI::Models::MembershipService
  describe LISMembershipContainer do
    it 'includes IMS::LTI::Models::Serializable' do
      includes = LISMembershipContainer.ancestors.select { |o| o.class == Module }
      expect(includes.include?(IMS::LTI::Models::Serializable)).to eq true
    end

    let(:container) do
        container = LISMembershipContainer.new({
          id: 1,
          membership_subject: serializable
        })
    end

    let(:serializable) do
      FakeSerializable.new
    end

    describe '#initialize' do
      it 'initializes properly' do
        expect(container.id).to eq 1
        expect(container.membership_subject).to eq serializable
        expect(container.membership_predicate).to eq 'http://www.w3.org/ns/org#membership'
        expect(container.type).to eq 'LISMembershipContainer'
        expect(container.context).to eq 'http://purl.imsglobal.org/ctx/lis/v2/MembershipContainer'
      end
    end

    describe '#as_json' do
      it 'serializes' do
        hash = container.as_json
        expect(hash.fetch(:membershipPredicate)).to eq 'http://www.w3.org/ns/org#membership'
        expect(hash.fetch(:membershipSubject)).to eq({})
        expect(hash.fetch(:@id)).to eq 1
        expect(hash.fetch(:@context)).to eq 'http://purl.imsglobal.org/ctx/lis/v2/MembershipContainer'
        expect(hash.fetch(:@type)).to eq 'LISMembershipContainer'
      end
    end
  end
end
