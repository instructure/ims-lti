module IMS::LTI::Models::ContentItems
  class LtiLinkItem < ContentItem

    add_attributes :custom

    TYPE = "LtiLinkItem"

    def initialize(attributes = {})
      super(attributes)
      self.type = TYPE
    end

  end
end
