module IMS::LTI::Models::MembershipService
  class Organization
    include IMS::LTI::Models::Serializable

    attr_reader :id, :membership, :name, :type

    def initialize(opts={})
      @id = opts[:id]
      @membership = opts[:membership]
      @name = opts[:name]
      @type = 'Organization'
    end
  end
end
