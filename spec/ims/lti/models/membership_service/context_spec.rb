require 'spec_helper'

module IMS::LTI::Models::MembershipService
  describe Context do
    it 'includes IMS::LTI::Models::Serializable' do
      includes = Context.ancestors.select { |o| o.class == Module }
      expect(includes.include?(IMS::LTI::Models::Serializable)).to eq true
    end

    let(:context) do
      context = Context.new({
        id: 1,
        membership: list_of_serializables,
        name: 'My Context',
        context_id: 1
      })
    end

    let(:list_of_serializables) do
      FakeListOfSerializables.new
    end

    describe '#initialize' do
      it 'initializes properly' do
        expect(context.id).to eq 1
        expect(context.membership).to eq list_of_serializables
        expect(context.name).to eq 'My Context'
        expect(context.type).to eq 'Context'
        expect(context.context_id).to eq 1
      end
    end

    describe '#as_json' do
      it 'serializes' do
        hash = context.as_json
        expect(hash.fetch(:@id)).to eq 1
        expect(hash.fetch(:name)).to eq 'My Context'
        expect(hash.fetch(:@type)).to eq 'Context'
        expect(hash.fetch(:contextId)).to eq 1
        expect(hash.fetch(:membership)).to eq []
      end
    end
  end
end
