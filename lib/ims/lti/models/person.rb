require_relative 'serializable'

module IMS::LTI::Models
  class Person < Agent
    include IMS::LTI::Models::Serializable

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
