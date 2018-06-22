module Ims::Lti::Claims
  RSpec.describe Context do
    let(:claim) { Context.new }

    describe 'validations' do
      it 'is not valid if "id" is not present' do
        expect(claim).to be_invalid
      end

      it 'is valid if "id" is present' do
        claim.id = SecureRandom.uuid
        expect(claim).to be_valid
      end
    end
  end
end