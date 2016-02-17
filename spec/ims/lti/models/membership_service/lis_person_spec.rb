require 'spec_helper'

module IMS::LTI::Models::MembershipService
  describe LISPerson do
    it 'includes IMS::LTI::Models::Serializable' do
      includes = LISPerson.ancestors.select { |o| o.class == Module }
      expect(includes.include?(IMS::LTI::Models::Serializable)).to eq true
    end

    describe '#initialize' do
      it 'initializes properly' do
        lis_person = LISPerson.new({
          id: 1,
          name: 'Test',
          family_name: 'Case',
          img: 'url',
          given_name: 'Test',
          email: 'email',
          result_sourced_id: 1,
          sourced_id: 1,
          user_id: 1
        })
        expect(lis_person.id).to eq 1
        expect(lis_person.name).to eq 'Test'
        expect(lis_person.family_name).to eq 'Case'
        expect(lis_person.img).to eq 'url'
        expect(lis_person.given_name).to eq 'Test'
        expect(lis_person.email).to eq 'email'
        expect(lis_person.result_sourced_id).to eq 1
        expect(lis_person.sourced_id).to eq 1
        expect(lis_person.user_id).to eq 1
      end
    end
  end
end
