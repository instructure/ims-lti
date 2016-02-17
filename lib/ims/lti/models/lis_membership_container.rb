require_relative 'serializable'

module IMS::LTI::Models
  class LISMembershipContainer < Container
    include IMS::LTI::Models::Serializable

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
