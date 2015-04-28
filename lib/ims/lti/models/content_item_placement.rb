module IMS::LTI::Models
  class ContentItemPlacement < LTIModel

    DOCUMENT_TARGETS = {
      embed: 'http://purl.imsglobal.org/vocab/lti/v2/lti#embed',
      frame: 'http://purl.imsglobal.org/vocab/lti/v2/lti#frame',
      iframe: 'http://purl.imsglobal.org/vocab/lti/v2/lti#iframe',
      none: 'http://purl.imsglobal.org/vocab/lti/v2/lti#none',
      overlay: 'http://purl.imsglobal.org/vocab/lti/v2/lti#overlay',
      popup: 'http://purl.imsglobal.org/vocab/lti/v2/lti#popup',
      window: 'http://purl.imsglobal.org/vocab/lti/v2/lti#window'
    }

    add_attribute :display_height, json_key: 'displayHeight'
    add_attribute :display_width, json_key: 'displayWidth'
    add_attribute :window_target, json_key: 'windowTarget'
    add_attribute :presentation_document_target, json_key: 'presentationDocumentTarget'

  end
end