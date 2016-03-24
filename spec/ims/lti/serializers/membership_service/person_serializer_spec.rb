require 'spec_helper'

module IMS::LTI::Serializers::MembershipService
  describe PersonSerializer do
    it 'serializes the right set of attributes' do
      expected_attributes = [:id, :name, :img, :family_name, :given_name]
      expect(PersonSerializer.attributes).to match_array expected_attributes
    end

    it 'has the right options set for the id attribute' do
      expected_options = {
        optional: false,
        key: :@id,
        has_serializable: false,
        has_list_of_serializables: false
      }
      expect(PersonSerializer.options_for_attribute(:id)).to eq expected_options
    end

    it 'has the right options set for the name attribute' do
      expected_options = {
        optional: false,
        key: nil,
        has_serializable: false,
        has_list_of_serializables: false
      }
      expect(PersonSerializer.options_for_attribute(:name)).to eq expected_options
    end

    it 'has the right options set for the image attribute' do
      expected_options = {
        optional: false,
        key: nil,
        has_serializable: false,
        has_list_of_serializables: false
      }
      expect(PersonSerializer.options_for_attribute(:image)).to eq expected_options
    end

    it 'has the right options set for the family_name attribute' do
      expected_options = {
        optional: false,
        key: :familyName,
        has_serializable: false,
        has_list_of_serializables: false
      }
      expect(PersonSerializer.options_for_attribute(:family_name)).to eq expected_options
    end

    it 'has the right options set for the given_name attribute' do
      expected_options = {
        optional: false,
        key: :givenName,
        has_serializable: false,
        has_list_of_serializables: false
      }
      expect(PersonSerializer.options_for_attribute(:given_name)).to eq expected_options
    end
  end
end

