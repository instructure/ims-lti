require 'spec_helper'

module IMS::LTI::Serializers::MembershipService
  describe LISMembershipContainerSerializer do
    it 'serializes the right set of attributes' do
      expected_attributes = [:id, :context, :type, :membership_predicate, :membership_subject]
      expect(LISMembershipContainerSerializer.attributes).to match_array expected_attributes
    end

    it 'has the right options set for the id attribute' do
      expected_options = {
        optional: false,
        key: :@id,
        has_serializable: false,
        has_list_of_serializables: false
      }
      expect(LISMembershipContainerSerializer.options_for_attribute(:id)).to eq expected_options
    end

    it 'has the right options set for the context attribute' do
      expected_options = {
        optional: false,
        key: :@context,
        has_serializable: false,
        has_list_of_serializables: false
      }
      expect(LISMembershipContainerSerializer.options_for_attribute(:context)).to eq expected_options
    end

    it 'has the right options set for the type attribute' do
      expected_options = {
        optional: false,
        key: :@type,
        has_serializable: false,
        has_list_of_serializables: false
      }
      expect(LISMembershipContainerSerializer.options_for_attribute(:type)).to eq expected_options
    end

    it 'has the right options set for the membership_predicate attribute' do
      expected_options = {
        optional: false,
        key: :membershipPredicate,
        has_serializable: false,
        has_list_of_serializables: false
      }
      expect(LISMembershipContainerSerializer.options_for_attribute(:membership_predicate))
        .to eq expected_options
    end

    it 'has the right options set for the membership_subject attribute' do
      expected_options = {
        optional: false,
        key: :membershipSubject,
        has_serializable: true,
        has_list_of_serializables: false
      }
      expect(LISMembershipContainerSerializer.options_for_attribute(:membership_subject))
        .to eq expected_options
    end

  end
end

