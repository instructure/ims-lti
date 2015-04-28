module IMS::LTI::Models::ContentItems
  class LtiLink < ContentItem

    add_attributes :custom

    TYPE = "FileItem"

    def initialize(attributes = {})
      super(attributes)
      self.type = TYPE
    end

  end
end