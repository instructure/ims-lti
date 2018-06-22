require 'active_model'

module Ims::Lti::Messages
  # Class represeting an LTI 1.3 resource link request.
  class LtiResourceLinkRequest
    include ActiveModel::Model
    include Ims::Lti::Concerns::TypedAttributes

    REQUIRED_CLAIMS = %i[
      aud
      azp
      deployment_id
      exp
      iat
      iss
      message_type
      nonce
      resource_link
      sub
      version
    ].freeze

    TYPED_ATTRIBUTES = {
      aud: Array,
      context: Ims::Lti::Claims::Context,
      extensions: Array,
      launch_presentation: Ims::Lti::Claims::LaunchPresentation,
      lis: Ims::Lti::Claims::Lis,
      tool_platform: Ims::Lti::Claims::Platform,
      resource_link: Ims::Lti::Claims::ResourceLink,
      roles: Array,
      role_scope_mentor: Array
    }.freeze

    validates_presence_of *REQUIRED_CLAIMS
    validates_each TYPED_ATTRIBUTES.keys do |record, attr, value|
      type_error = validate_types(TYPED_ATTRIBUTES[attr], attr, value)
      record.errors.add attr, type_error unless type_error.nil?

      attribute_error = validate_attribute(value)
      record.errors.add attr, attribute_error unless attribute_error.nil?
    end

    attr_accessor *REQUIRED_CLAIMS
    attr_accessor :address,
                  :birthdate,
                  :context,
                  :custom,
                  :email,
                  :email_verified,
                  :extensions,
                  :family_name,
                  :gender,
                  :given_name,
                  :launch_presentation,
                  :lis,
                  :locale,
                  :middle_name,
                  :name,
                  :nickname,
                  :phone_number,
                  :phone_number_verified,
                  :picture,
                  :platform,
                  :preferred_username,
                  :profile,
                  :roles,
                  :role_scope_mentor,
                  :updated_at,
                  :website,
                  :zoneinfo

    # Returns a new instance of LtiResourceLinkRequest.
    #
    # @param [Hash] attributes for message initialization.
    # @return [LtiResourceLinkRequest]
    def initialize(params = {})
      super
      self.message_type = 'LtiResourceLinkRequest'
      self.version = '1.3.0'
    end
  end
end