require 'spec_helper'

module IMS::LTI::Models::MembershipService
  describe Page do
    it 'includes IMS::LTI::Models::Serializable' do
      includes = Page.ancestors.select { |o| o.class == Module }
      expect(includes.include?(IMS::LTI::Models::Serializable)).to eq true
    end

    describe '#initialize' do
      it 'initializes properly' do
        page = Page.new({
          id: 1,
          differences: 'url',
          page_of: 2,
          next_page: 'url'
        })
        expect(page.id).to eq 1
        expect(page.type).to eq 'Page'
        expect(page.context).to eq 'http://purl.imsglobal.org/ctx/lis/v2/MembershipContainer'
        expect(page.differences).to eq 'url'
        expect(page.page_of).to eq 2
        expect(page.next_page).to eq 'url'
      end
    end
  end
end
