module IMS::LTI::Models
  class MessageHandler < LTIModel
    add_attributes :message_type, :path, :enabled_capability
    add_attribute :parameter, relation:'IMS::LTI::Models::Parameter'

    def enabled_capabilities
      [*enabled_capability]
    end

    def parameters
      [*parameter]
    end
  end
end