require 'active_support/concern'

# Module providing model and serialization methods to messages.
module Ims::Lti::Models::Messages::Concerns::SerializedParameters
  extend ActiveSupport::Concern
  include ActiveModel::Model
  include ActiveModel::Serialization

  class_methods do
    def attr_accessor(*args)
      @accessible_attributes = args
      super(*args)
    end

    # Returns an array of all accessible attributes in the model.
    #
    # @return [Array]
    def accessible_attributes
      @accessible_attributes
    end
  end

  included do
    def attributes
      self.class.accessible_attributes.each_with_object({}) do |a, h|
        h[a] = nil
      end
    end

    # Returns a hash of all parameters and their current values.
    #
    # @return [Hash]
    def parameters
      serializable_hash
    end
  end
end