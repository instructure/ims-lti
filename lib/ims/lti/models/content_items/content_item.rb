module IMS::LTI::Models::ContentItems
  class ContentItem < IMS::LTI::Models::LTIModel

    add_attributes :media_type, :text, :title, :url
    add_attribute :type, json_key: '@type'
    add_attribute :id, json_key: '@id'
    add_attribute :icon, relation: 'IMS::LTI::Models::Image'
    add_attribute :placement_advice, relation: 'IMS::LTI::Models::ContentItemPlacement'
    add_attribute :thumbnail, relation: 'IMS::LTI::Models::Image'

    TYPE = "ContentItem"

    def initialize(attributes = {})
      super(attributes)
      self.type = TYPE
    end

    def self.from_json(json)
      data = json.is_a?(String) ? JSON.parse(json) : json
      case data['@type']
        when 'ContentItem'
          ContentItem.new.from_json(data)
        when 'FileItem'
          FileItem.new.from_json(data)
        when 'LtiLink'
          LtiLink.new.from_json(data)
      end
    end

  end
end