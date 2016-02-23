require 'spec_helper'

module IMS::LTI::Models::MembershipService
  describe Person do
    it 'includes IMS::LTI::Models::Serializable' do
      includes = Person.ancestors.select { |o| o.class == Module }
      expect(includes.include?(IMS::LTI::Models::Serializable)).to eq true
    end

    describe '#initialize' do
      it 'initializes properly' do
        person = Person.new({
          id: 1,
          name: 'Test',
          family_name: 'Case',
          img: 'url',
          given_name: 'Test'
        })
        expect(person.id).to eq 1
        expect(person.name).to eq 'Test'
        expect(person.family_name).to eq 'Case'
        expect(person.img).to eq 'url'
        expect(person.given_name).to eq 'Test'
      end
    end
  end
end
