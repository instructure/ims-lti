module IMS::LTI::Models::ContentItems
  class FileItem < ContentItem

    add_attribute :copy_advice, json_key: 'copyAdvice'
    add_attribute :expires_at, json_key: 'expiresAt'

    TYPE = "FileItem"

    def initialize(attributes = {})
      super(attributes)
      self.type = TYPE
    end

  end
end