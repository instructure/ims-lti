require 'spec_helper'

module IMS::LTI::Models::MembershipService
  describe Agent do
    it 'includes IMS::LTI::Models::Serializable' do
      includes = Agent.ancestors.select { |o| o.class == Module }
      expect(includes.include?(IMS::LTI::Models::Serializable)).to eq true
    end

    let(:agent) do
      agent = Agent.new({id: 1})
    end

    describe '#initialize' do
      it 'initializes properly' do
        expect(agent.id).to eq 1
      end
    end

    describe '#as_json' do
      it 'serializes' do
        hash = agent.as_json
        expect(hash.fetch(:@id)).to eq 1
      end
    end
  end
end
