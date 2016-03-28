require 'spec_helper'

module IMS::LTI::Serializers::MembershipService
  describe LISPersonSerializer do
    it 'serializes the right set of attributes' do
      expected_attributes = [:id, :name, :img, :email, :family_name, :given_name,
        :result_sourced_id, :sourced_id, :user_id]
      expect(LISPersonSerializer.attributes).to match_array expected_attributes
    end

    it 'has the right options set for the id attribute' do
      expected_options = {
        optional: false,
        key: :@id,
        has_serializable: false,
        has_list_of_serializables: false
      }
      expect(LISPersonSerializer.options_for_attribute(:id)).to eq expected_options
    end

    it 'has the right options set for the name attribute' do
      expected_options = {
        optional: false,
        key: nil,
        has_serializable: false,
        has_list_of_serializables: false
      }
      expect(LISPersonSerializer.options_for_attribute(:name)).to eq expected_options
    end

    it 'has the right options set for the img attribute' do
      expected_options = {
        optional: false,
        key: nil,
        has_serializable: false,
        has_list_of_serializables: false
      }
      expect(LISPersonSerializer.options_for_attribute(:img)).to eq expected_options
    end

    it 'has the right options set for the email attribute' do
      expected_options = {
        optional: false,
        key: nil,
        has_serializable: false,
        has_list_of_serializables: false
      }
      expect(LISPersonSerializer.options_for_attribute(:email)).to eq expected_options
    end

    it 'has the right options set for the family_name attribute' do
      expected_options = {
        optional: false,
        key: :familyName,
        has_serializable: false,
        has_list_of_serializables: false
      }
      expect(LISPersonSerializer.options_for_attribute(:family_name)).to eq expected_options
    end

    it 'has the right options set for the given_name attribute' do
      expected_options = {
        optional: false,
        key: :givenName,
        has_serializable: false,
        has_list_of_serializables: false
      }
      expect(LISPersonSerializer.options_for_attribute(:given_name)).to eq expected_options
    end

    it 'has the right options set for the result_sourced_id attribute' do
      expected_options = {
        optional: false,
        key: :resultSourcedId,
        has_serializable: false,
        has_list_of_serializables: false
      }
      expect(LISPersonSerializer.options_for_attribute(:result_sourced_id)).to eq expected_options
    end

    it 'has the right options set for the sourced_id attribute' do
      expected_options = {
        optional: false,
        key: :sourcedId,
        has_serializable: false,
        has_list_of_serializables: false
      }
      expect(LISPersonSerializer.options_for_attribute(:sourced_id)).to eq expected_options
    end

    it 'has the right options set for the user_id attribute' do
      expected_options = {
        optional: false,
        key: :userId,
        has_serializable: false,
        has_list_of_serializables: false
      }
      expect(LISPersonSerializer.options_for_attribute(:user_id)).to eq expected_options
    end
  end
end

