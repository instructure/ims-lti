require_relative 'serializable'

module IMS::LTI::Models
  class Container
    include IMS::LTI::Models::Serializable

    attr_reader :membership_predicate, :membership_subject

    class << self
      protected :new
    end

    def initialize(opts={})
      @membership_subject = opts[:membership_subject]
    end
  end
end
