require 'spec_helper'

module IMS::LTI::Models::MembershipService
  describe Organization do
    it 'includes IMS::LTI::Models::Serializable' do
      includes = Organization.ancestors.select { |o| o.class == Module }
      expect(includes.include?(IMS::LTI::Models::Serializable)).to eq true
    end

    let(:org) do
      Organization.new({
        id: 1,
        membership: list_of_serializables,
        name: 'My Organization'
      })
    end

    let(:list_of_serializables) do
      FakeListOfSerializables.new
    end

    describe '#initialize' do
      it 'initializes properly' do
        expect(org.id).to eq 1
        expect(org.membership).to eq list_of_serializables
        expect(org.name).to eq 'My Organization'
        expect(org.type).to eq 'Organization'
      end
    end

    describe '#as_json' do
      it 'serializes' do
        hash = org.as_json
        expect(hash.fetch(:@id)).to eq 1
        expect(hash.fetch(:name)).to eq 'My Organization'
        expect(hash.fetch(:@type)).to eq 'Organization'
        expect(hash.fetch(:membership)).to eq []
      end
    end
  end
end
