module IMS::LTI::Models::ContentItems
  class ContentItem < IMS::LTI::Models::LTIModel

    add_attributes :text, :title, :url, :confirmUrl
    add_attribute :media_type, json_key: 'mediaType'
    add_attribute :type, json_key: '@type'
    add_attribute :id, json_key: '@id'
    add_attribute :icon, relation: 'IMS::LTI::Models::Image'
    add_attribute :placement_advice, json_key:'placementAdvice', relation: 'IMS::LTI::Models::ContentItemPlacement'
    add_attribute :thumbnail, relation: 'IMS::LTI::Models::Image'

    TYPE = "ContentItem"

    def initialize(attributes = {})
      super(attributes)
      self.type = TYPE
    end

    def self.from_json(json)
      data = json.is_a?(String) ? JSON.parse(json) : json
      case data['@type']
      when 'FileItem'
        FileItem.new.from_json(data)
      when 'LtiLinkItem', 'LtiLink'
        LtiLinkItem.new.from_json(data)
      else
        ContentItem.new.from_json(data)
      end
    end

  end
end
