module IMS::LTI::Models::MembershipService
  class LISMembershipContainer < Container
    attr_reader :context, :type, :id

    def initialize(opts={})
      super(opts)
      @id = opts[:id]
      @context = 'http://purl.imsglobal.org/ctx/lis/v2/MembershipContainer'
      @type = 'LISMembershipContainer'
      @membership_predicate = 'http://www.w3.org/ns/org#membership'
    end
  end
end
