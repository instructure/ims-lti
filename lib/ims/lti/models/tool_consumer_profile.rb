module IMS::LTI::Models
  class ToolConsumerProfile < LTIModel

    CONTEXT = "http://purl.imsglobal.org/ctx/lti/v2/ToolConsumerProfile"
    TYPE = "ToolConsumerProfile"

    MESSAGING_CAPABILITIES = %w(basic-lti-launch-request)
    OUTCOMES_CAPABILITIES = %w(Result.autocreate)

    add_attributes :lti_version, :guid, :capability_offered, :security_profile
    add_attribute :id, json_key:'@id'
    add_attribute :type, json_key:'@type'
    add_attribute :context, json_key:'@context'
    add_attribute :product_instance, relation:'IMS::LTI::Models::ProductInstance'
    add_attribute :service_offered, relation: 'IMS::LTI::Models::RestService'

    def initialize(attr = {})
      @context = [CONTEXT]
      @type = TYPE
      super(attr)
    end

    def services_offered
      [*@service_offered]
    end

    def capabilities_offered
      [*@capability_offered]
    end

    def security_profiles
      [*@security_profile]
    end

    def reregistration_capable?
      @capability_offered.include?(Messages::ToolProxyReregistrationRequest::MESSAGE_TYPE)
    end

    def supports_capabilities?(capability, *capabilities)
      capabilities.unshift(capability)
      (capabilities - capabilities_offered).empty?
    end

  end
end
