require 'active_support/concern'

module Ims::Lti::Concerns::TypedAttributes
  extend ActiveSupport::Concern

  class_methods do
    def validate_types(expected_type, attr, value)
      return if value.nil? || expected_type.nil?
      unless value.instance_of? expected_type
        "#{attr} must be an intance of #{expected_type}"
      end
    end

    def validate_attribute(value)
      return unless value.respond_to?(:invalid?)
      value.errors.messages unless value.errors.messages.blank?
    end
  end
end
