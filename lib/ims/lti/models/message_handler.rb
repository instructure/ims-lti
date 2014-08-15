module IMS::LTI::Models
  class MessageHandler < LTIModel
    add_attributes :message_type, :path, :enabled_capability
    add_attribute :parameter, relation:'IMS::LTI::Models::Parameter'
  end
end