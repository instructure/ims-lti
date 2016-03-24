require 'spec_helper'

module IMS::LTI::Models::MembershipService
  describe Membership do
    it 'includes IMS::LTI::Models::Serializable' do
      includes = Membership.ancestors.select { |o| o.class == Module }
      expect(includes.include?(IMS::LTI::Models::Serializable)).to eq true
    end

    let(:membership) do
      membership = Membership.new({
        id: 1,
        status: 2,
        member: serializable,
        role: 4
      })
    end

    let(:serializable) do
      FakeSerializable.new
    end

    describe '#initialize' do
      it 'initializes properly' do
        expect(membership.id).to eq 1
        expect(membership.status).to eq 2
        expect(membership.member).to eq serializable
        expect(membership.role).to eq 4
      end
    end

    describe '#as_json' do
      it 'serializes' do
        hash = membership.as_json
        expect(hash.fetch(:@id)).to eq 1
        expect(hash.fetch(:status)).to eq 2
        expect(hash.fetch(:role)).to eq 4
        expect(hash.fetch(:member)).to eq({})
      end
    end
  end
end
