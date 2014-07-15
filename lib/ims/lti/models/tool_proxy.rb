module IMS::LTI::Models
  class ToolProxy < LTIModel
    add_attributes :lti_version, :tool_proxy_guid, :custom, :custom_url, :enabled_capability
    add_attribute :context, json_key:'@context'
    add_attribute :type, json_key:'@type'
    add_attribute :id, json_key:'@id'
    add_attribute :tool_consumer_profile
    add_attribute :tool_profile, relation:'IMS::LTI::Models::ToolProfile'
    add_attribute :security_contract, relation:'IMS::LTI::Models::SecurityContract'
  end
end