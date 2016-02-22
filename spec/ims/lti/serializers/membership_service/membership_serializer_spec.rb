require 'spec_helper'

module IMS::LTI::Serializers::MembershipService
  describe MembershipSerializer do
    it 'serializes the right set of attributes' do
      expected_attributes = [:id, :status, :role, :member]
      expect(MembershipSerializer.attributes).to match_array expected_attributes
    end

    it 'has the right options set for the id attribute' do
      expected_options = {
        optional: false,
        key: :@id,
        has_serializable: false,
        has_list_of_serializables: false
      }
      expect(MembershipSerializer.options_for_attribute(:id)).to eq expected_options
    end

    it 'has the right options set for the status attribute' do
      expected_options = {
        optional: false,
        key: nil,
        has_serializable: false,
        has_list_of_serializables: false
      }
      expect(MembershipSerializer.options_for_attribute(:status)).to eq expected_options
    end

    it 'has the right options set for the role attribute' do
      expected_options = {
        optional: false,
        key: nil,
        has_serializable: false,
        has_list_of_serializables: false
      }
      expect(MembershipSerializer.options_for_attribute(:role)).to eq expected_options
    end

    it 'has the right options set for the member attribute' do
      expected_options = {
        optional: false,
        key: nil,
        has_serializable: true,
        has_list_of_serializables: false
      }
      expect(MembershipSerializer.options_for_attribute(:member)).to eq expected_options
    end

  end
end

