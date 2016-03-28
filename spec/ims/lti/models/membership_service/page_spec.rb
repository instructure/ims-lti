require 'spec_helper'

module IMS::LTI::Models::MembershipService
  describe Page do
    it 'includes IMS::LTI::Models::Serializable' do
      includes = Page.ancestors.select { |o| o.class == Module }
      expect(includes.include?(IMS::LTI::Models::Serializable)).to eq true
    end

    let(:page) do
      Page.new({
        id: 1,
        differences: 'url',
        page_of: serializable,
        next_page: 'url'
      })
    end

    let(:serializable) do
      FakeSerializable.new
    end

    describe '#initialize' do
      it 'initializes properly' do
        expect(page.id).to eq 1
        expect(page.type).to eq 'Page'
        expect(page.context).to eq 'http://purl.imsglobal.org/ctx/lis/v2/MembershipContainer'
        expect(page.differences).to eq 'url'
        expect(page.page_of).to eq serializable
        expect(page.next_page).to eq 'url'
      end
    end

    describe '#as_json' do
      it 'serializes' do
        hash = page.as_json
        expect(hash.fetch(:@id)).to eq 1
        expect(hash.fetch(:@type)).to eq 'Page'
        expect(hash.fetch(:@context)).to eq 'http://purl.imsglobal.org/ctx/lis/v2/MembershipContainer'
        expect(hash.fetch(:differences)).to eq 'url'
        expect(hash.fetch(:nextPage)).to eq 'url'
        expect(hash.fetch(:pageOf)).to eq({})
      end
    end
  end
end
