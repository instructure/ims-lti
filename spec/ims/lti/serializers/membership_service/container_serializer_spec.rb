require 'spec_helper'

module IMS::LTI::Serializers::MembershipService
  describe ContainerSerializer do
    it 'serializes the right set of attributes' do
      expected_attributes = [:membership_predicate, :membership_subject]
      expect(ContainerSerializer.attributes).to match_array expected_attributes
    end

    it 'has the right options set for the membership_predicate attribute' do
      expected_options = {
        optional: false,
        key: :membershipPredicate,
        has_serializable: false,
        has_list_of_serializables: false
      }
      expect(ContainerSerializer.options_for_attribute(:membership_predicate)).to eq expected_options
    end

    it 'has the right options set for the membership_subject attribute' do
      expected_options = {
        optional: false,
        key: :membershipSubject,
        has_serializable: true,
        has_list_of_serializables: false
      }
      expect(ContainerSerializer.options_for_attribute(:membership_subject)).to eq expected_options
    end
  end
end

