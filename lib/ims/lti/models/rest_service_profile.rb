module IMS::LTI::Models
  class RestServiceProfile < LTIModel
    add_attributes :service, :action
    add_attribute :type, json_key: '@type'

  end
end