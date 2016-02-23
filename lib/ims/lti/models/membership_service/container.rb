module IMS::LTI::Models::MembershipService
  class Container
    include IMS::LTI::Models::Serializable

    attr_reader :membership_predicate, :membership_subject

    def initialize(opts={})
      @membership_subject = opts[:membership_subject]
    end
  end
end
