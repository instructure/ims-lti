require 'active_model'

module Ims::Lti::Models
  class ContentItem
    include ActiveModel::Model

    REQUIRED_ELEMENTS = %i[
      mediaType
    ]

    validates_presence_of *REQUIRED_ELEMENTS
    attr_accessor *REQUIRED_ELEMENTS
    attr_accessor :type,
                  :id,
                  :url,
                  :title,
                  :icon,
                  :thumbnail,
                  :text,
                  :custom,
                  :copyAdvice,
                  :expiresAt,
                  :presentationDocumentTarget,
                  :windowTarget,
                  :displayWidth,
                  :displayHeight

    validates_each :icon, :thumbnail do |record, attr, value|
      next if value.nil?
      record.errors.add attr, "#{attr} must be an intance of #{Image.to_s}." unless value.instance_of? Image
    end
  end
end
