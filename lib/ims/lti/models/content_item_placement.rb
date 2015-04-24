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

    add_attributes :display_height, :display_width, :window_target
    add_attribute :presentation_document_target

  end
end