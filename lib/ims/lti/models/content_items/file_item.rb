module IMS::LTI::Models::ContentItems
  class FileItem < ContentItem

    add_attributes :copyAdvice, :expires_at

    TYPE = "FileItem"

    def initialize(attributes = {})
      super(attributes)
      self.type = TYPE
    end

  end
end