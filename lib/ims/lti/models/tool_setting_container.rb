module IMS::LTI::Models
  class ToolSettingContainer < LTIModel
    add_attribute :context, json_key: '@context'
    add_attribute :graph, json_key: '@graph', relation: 'IMS::LTI::Models::ToolSetting'

    TOOL_SETTING_CONTAINER_CONTEXT = 'http://purl.imsglobal.org/ctx/lti/v2/ToolSettings'

    def initialize(opts = {})
      super(opts)
      self.context = TOOL_SETTING_CONTAINER_CONTEXT
    end

  end
end