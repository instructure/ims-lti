require 'spec_helper'

module IMS::LTI::Serializers::MembershipService
  describe PageSerializer do
    it 'serializes the right set of attributes' do
      expected_attributes = [:id, :type, :context, :differences, :next_page, :page_of]
      expect(PageSerializer.attributes).to match_array expected_attributes
    end

    it 'has the right options set for the id attribute' do
      expected_options = {
        optional: false,
        key: :@id,
        has_serializable: false,
        has_list_of_serializables: false
      }
      expect(PageSerializer.options_for_attribute(:id)).to eq expected_options
    end

    it 'has the right options set for the type attribute' do
      expected_options = {
        optional: false,
        key: :@type,
        has_serializable: false,
        has_list_of_serializables: false
      }
      expect(PageSerializer.options_for_attribute(:type)).to eq expected_options
    end

    it 'has the right options set for the context attribute' do
      expected_options = {
        optional: false,
        key: :@context,
        has_serializable: false,
        has_list_of_serializables: false
      }
      expect(PageSerializer.options_for_attribute(:context)).to eq expected_options
    end

    it 'has the right options set for the differences attribute' do
      expected_options = {
        optional: false,
        key: nil,
        has_serializable: false,
        has_list_of_serializables: false
      }
      expect(PageSerializer.options_for_attribute(:differences)).to eq expected_options
    end

    it 'has the right options set for the next_page attribute' do
      expected_options = {
        optional: false,
        key: :nextPage,
        has_serializable: false,
        has_list_of_serializables: false
      }
      expect(PageSerializer.options_for_attribute(:next_page)).to eq expected_options
    end

    it 'has the right options set for the page_of attribute' do
      expected_options = {
        optional: false,
        key: :pageOf,
        has_serializable: true,
        has_list_of_serializables: false
      }
      expect(PageSerializer.options_for_attribute(:page_of)).to eq expected_options
    end

  end
end

