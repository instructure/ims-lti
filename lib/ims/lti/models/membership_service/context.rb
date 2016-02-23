module IMS::LTI::Models::MembershipService
  class Context < Organization
    attr_reader :context_id

    def initialize(opts={})
      super(opts)
      @type = 'Context'
      @context_id = opts[:context_id]
    end
  end
end
