require 'active_model'

module Ims::Lti::Models::Messages
  # Abstract base class for all messages.
  #
  # @attr [Hash] extensions Message parameters not defined in the specification.
  # @attr [Hash] custom Parameters specified by the tool provider.
  class Message
    include ActiveModel::Model
    include ActiveModel::Serialization
    include ActiveModel::Validations

    attr_accessor :extensions, :custom

    def initialize(params = {})
      singleton_class.class_eval do
        attr_accessor *(required_parameters + recommended_parameters + optional_parameters)
        validates *required_parameters, presence: true
      end
      super
    end

    class << self
      def required_parameters
        raise 'Override "required_parameters" in child class'
      end

      def recommended_parameters
        raise 'Override "recommended_parameters" in child class'
      end

      def optional_parameters
        raise 'Override "optional_parameters" in child class'
      end

      def all_parameters
        required_parameters +
        recommended_parameters +
        optional_parameters +
        [:extensions, :custom]
      end
    end

    # Returns all parameters for the launch.
    #
    # @return [Hash] all launch parameters.
    def parameters
      serializable_hash
    end

    private

    def attributes
      @_attributes ||= self.class.all_parameters.each_with_object({}) { |a, h| h[a] = nil }
    end
  end
end