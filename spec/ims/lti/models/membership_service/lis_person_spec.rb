require 'spec_helper'

module IMS::LTI::Models::MembershipService
  describe LISPerson do
    let(:lis_person_params) do
      {
        id: 1,
        name: 'Test',
        family_name: 'Case',
        img: 'url',
        given_name: 'Test',
        email: 'email',
        result_sourced_id: 1,
        sourced_id: 1,
        user_id: 1
      }
    end
    let(:lis_person) do
      lis_person = LISPerson.new(lis_person_params)
    end

    it 'includes IMS::LTI::Models::Serializable' do
      includes = LISPerson.ancestors.select { |o| o.class == Module }
      expect(includes.include?(IMS::LTI::Models::Serializable)).to eq true
    end

    describe '#initialize' do
      it 'initializes properly' do
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

    describe '#as_json' do
      it 'serializes' do
        hash = lis_person.as_json
        expect(hash.fetch(:@id)).to eq 1
        expect(hash.fetch(:name)).to eq 'Test'
        expect(hash.fetch(:img)).to eq 'url'
        expect(hash.fetch(:email)).to eq 'email'
        expect(hash.fetch(:familyName)).to eq 'Case'
        expect(hash.fetch(:givenName)).to eq 'Test'
        expect(hash.fetch(:resultSourcedId)).to eq 1
        expect(hash.fetch(:sourcedId)).to eq 1
        expect(hash.fetch(:userId)).to eq 1
        expect(hash).not_to have_key(:sis_id)
      end

      context 'with sis_id' do
        let(:lis_person_params) do
          super().merge(sis_id: 'test')
        end

        it 'serializes' do
          hash = lis_person.as_json
          expect(hash.fetch(:@id)).to eq 1
          expect(hash.fetch(:name)).to eq 'Test'
          expect(hash.fetch(:img)).to eq 'url'
          expect(hash.fetch(:email)).to eq 'email'
          expect(hash.fetch(:familyName)).to eq 'Case'
          expect(hash.fetch(:givenName)).to eq 'Test'
          expect(hash.fetch(:resultSourcedId)).to eq 1
          expect(hash.fetch(:sourcedId)).to eq 1
          expect(hash.fetch(:userId)).to eq 1
          expect(hash.fetch(:sisId)).to eq 'test'
        end
      end
    end
  end
end
