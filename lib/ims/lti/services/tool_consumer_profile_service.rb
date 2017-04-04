module IMS::LTI::Services
  class ToolConsumerProfileService

    attr_accessor :tcp

    def initialize(tool_consumer_profile)
      @tcp = tool_consumer_profile
    end

    def supports_capabilities?(capability, *capabilities)
      capabilities.unshift(capability)
      (capabilities - tcp.capabilities_offered).empty?
    end

  end
end