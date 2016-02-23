module IMS::LTI::Models::MembershipService
  class Agent
    include IMS::LTI::Models::Serializable

    attr_reader :id

    def initialize(opts={})
      @id = opts[:id]
    end
  end
end
