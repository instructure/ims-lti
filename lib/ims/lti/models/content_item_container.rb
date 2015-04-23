module IMS::LTI::Models
  class ContentItemContainer < IMS::LTI::Models::LTIModel
    add_attribute :context, json_key: '@context'
    add_attribute :graph, json_key: '@graph', relation: 'IMS::LTI::Models::ContentItems::ContentItem'

    CONTENT_ITEM_CONTAINER_CONTEXT = 'http://purl.imsglobal.org/ctx/lti/v1/ContentItem'

    def initialize(opts = {})
      super(opts)
      self.context = CONTENT_ITEM_CONTAINER_CONTEXT
    end

  end
end