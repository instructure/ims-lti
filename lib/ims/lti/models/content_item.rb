require_relative 'concerns'

module Ims::Lti::Models
  class ContentItem
    include Ims::Lti::Models::Concerns::SerializedParameters
    include ActiveModel::Validations

    attr_accessor :type,
                  :id,
                  :url,
                  :title,
                  :mediaType,
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
      record.errors.add attr, "#{attr} must be an intance of #{Image.to_s}." unless value.instance_of? Image
    end
  end
end