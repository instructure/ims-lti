module IMS::LTI::Models::MembershipService
  class Person < Agent
    attr_reader :family_name, :name, :img, :given_name

    def initialize(opts={})
      super(opts)
      @family_name = opts[:family_name]
      @name = opts[:name]
      @img = opts[:img]
      @given_name = opts[:given_name]
    end
  end
end
