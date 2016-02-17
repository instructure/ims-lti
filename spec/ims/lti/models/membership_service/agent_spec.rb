require 'spec_helper'

module IMS::LTI::Models::MembershipService
  describe Agent do
    it 'includes IMS::LTI::Models::Serializable' do
      includes = Agent.ancestors.select { |o| o.class == Module }
      expect(includes.include?(IMS::LTI::Models::Serializable)).to eq true
    end

    describe '#initialize' do
      it 'initializes properly' do
        agent = Agent.new({id: 1})
        expect(agent.id).to eq 1
      end
    end
  end
end
