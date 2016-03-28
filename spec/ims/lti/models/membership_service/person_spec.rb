require 'spec_helper'

module IMS::LTI::Models::MembershipService
  describe Person do
    it 'includes IMS::LTI::Models::Serializable' do
      includes = Person.ancestors.select { |o| o.class == Module }
      expect(includes.include?(IMS::LTI::Models::Serializable)).to eq true
    end

    let(:person) do
      Person.new({
        id: 1,
        name: 'Test',
        family_name: 'Case',
        img: 'url',
        given_name: 'Test'
      })
    end

    describe '#initialize' do
      it 'initializes properly' do
        expect(person.id).to eq 1
        expect(person.name).to eq 'Test'
        expect(person.family_name).to eq 'Case'
        expect(person.img).to eq 'url'
        expect(person.given_name).to eq 'Test'
      end
    end

    describe '#as_json' do
      it 'serializes' do
        hash = person.as_json
        expect(hash.fetch(:@id)).to eq 1
        expect(hash.fetch(:name)).to eq 'Test'
        expect(hash.fetch(:img)).to eq 'url'
        expect(hash.fetch(:familyName)).to eq 'Case'
        expect(hash.fetch(:givenName)).to eq 'Test'
      end
    end
  end
end
