require 'spec_helper'

module IMS::LTI::Models::MembershipService
  describe Container do
    it 'includes IMS::LTI::Models::Serializable' do
      includes = Container.ancestors.select { |o| o.class == Module }
      expect(includes.include?(IMS::LTI::Models::Serializable)).to eq true
    end

    describe '#initialize' do
      it 'initializes properly' do
        container = Container.new({
          membership_subject: 1
        })
        expect(container.membership_subject).to eq 1
      end
    end
  end
end
