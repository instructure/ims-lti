module IMS::LTI::Models::MembershipService
  class LISPerson < Person
    attr_reader :email, :result_sourced_id, :sourced_id, :user_id

    def initialize(opts={})
      super(opts)
      @email = opts[:email]
      @result_sourced_id = opts[:result_sourced_id]
      @sourced_id = opts[:sourced_id]
      @user_id = opts[:user_id]
    end
  end
end
