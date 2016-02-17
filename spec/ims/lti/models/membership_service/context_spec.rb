require 'spec_helper'

module IMS::LTI::Models::MembershipService
  describe Context do
    it 'includes IMS::LTI::Models::Serializable' do
      includes = Context.ancestors.select { |o| o.class == Module }
      expect(includes.include?(IMS::LTI::Models::Serializable)).to eq true
    end

    describe '#initialize' do
      it 'initializes properly' do
        context = Context.new({
          id: 1,
          membership: 1,
          name: 'My Context',
          context_id: 1
        })
        expect(context.id).to eq 1
        expect(context.membership).to eq 1
        expect(context.name).to eq 'My Context'
        expect(context.type).to eq 'Context'
        expect(context.context_id).to eq 1
      end
    end
  end
end
