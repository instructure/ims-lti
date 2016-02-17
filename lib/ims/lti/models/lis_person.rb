require_relative 'serializable'

module IMS::LTI::Models
  class LISPerson < Person
    include IMS::LTI::Models::Serializable

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
