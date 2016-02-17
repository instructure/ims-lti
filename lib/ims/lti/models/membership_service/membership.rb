module IMS::LTI::Models::MembershipService
  class Membership
    include IMS::LTI::Models::Serializable

    attr_reader :id, :status, :member, :role

    def initialize(opts={})
      @id = opts[:id]
      @status = opts[:status]
      @member = opts[:member]
      @role = opts[:role]
    end
  end
end
