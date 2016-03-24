require 'spec_helper'

module IMS::LTI::Models::MembershipService
  describe Container do
    it 'includes IMS::LTI::Models::Serializable' do
      includes = Container.ancestors.select { |o| o.class == Module }
      expect(includes.include?(IMS::LTI::Models::Serializable)).to eq true
    end

    let(:container) do
      container = Container.new({
        membership_subject: serializable
      })
    end

    let(:serializable) do
      FakeSerializable.new
    end

    describe '#initialize' do
      it 'initializes properly' do
        expect(container.membership_subject).to eq(serializable)
      end
    end

    describe '#as_json' do
      it 'serializes' do
        hash = container.as_json
        expect(hash.fetch(:membershipPredicate)).to be_nil
        expect(hash.fetch(:membershipSubject)).to eq({})
      end
    end
  end
end
