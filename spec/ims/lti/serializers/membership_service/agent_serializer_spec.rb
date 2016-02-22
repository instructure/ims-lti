require 'spec_helper'

module IMS::LTI::Serializers::MembershipService
  describe AgentSerializer do
    it 'serializes the right set of attributes' do
      expected_attributes = [:id]
      expect(AgentSerializer.attributes).to match_array expected_attributes
    end

    it 'has the right options set for the id attribute' do
      expected_options = {
        optional: false,
        key: :@id,
        has_serializable: false,
        has_list_of_serializables: false
      }
      expect(AgentSerializer.options_for_attribute(:id)).to eq expected_options
    end
  end
end

