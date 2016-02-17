require_relative 'serializable'

module IMS::LTI::Models
  class Agent
    include IMS::LTI::Models::Serializable

    attr_reader :id

    def initialize(opts={})
      @id = opts[:id]
    end
  end
end
