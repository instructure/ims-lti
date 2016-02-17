module IMS::LTI::Models::MembershipService
  class Page
    include IMS::LTI::Models::Serializable

    attr_reader :id, :type, :context, :differences, :page_of, :next_page

    def initialize(opts={})
      @id = opts[:id]
      @type = 'Page'
      @context = 'http://purl.imsglobal.org/ctx/lis/v2/MembershipContainer'
      @differences = opts[:differences]
      @page_of = opts[:page_of]
      @next_page = opts[:next_page]
    end
  end
end
