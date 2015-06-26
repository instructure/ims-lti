module IMS::LTI::Models
  class ToolSetting < LTIModel
    add_attribute :type, json_key: '@type'
    add_attribute :id, json_key: '@id'
    add_attributes :custom, :custom_url

    TOOL_PROXY_BINDING_TYPE = 'ToolProxyBinding'
    TOOL_PROXY_TYPE = 'ToolProxy'
    LTI_LINK_TYPE = 'LtiLink'

  end
end
