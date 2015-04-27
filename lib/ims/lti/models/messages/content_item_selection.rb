module IMS::LTI::Models::Messages
  class ContentItemSelection < Message
    add_optional_params :content_items, :data, :lti_msg, :lti_log, :lti_errormsg, :lti_errorlog

    MESSAGE_TYPE = 'ContentItemSelection'

    def initialize(attrs = {})
      super(attrs)
      self.lti_message_type = MESSAGE_TYPE
    end

    def content_items=(ci)
      if ci.instance_of? String
        container = IMS::LTI::Models::ContentItemContainer.from_json ci
        @content_items = container.graph
      else
        @content_items = ci
      end
    end

    def parameters
      if content_items
        params = self.class.send("parameters")
        params.delete('content_items')
        collect_attributes(params).merge({'content_items' => IMS::LTI::Models::ContentItemContainer.new(graph: content_items).to_json})
      else
        super
      end
    end

  end
end
