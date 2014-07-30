module IMS::LTI::Models
  class RestServiceProfile < LTIModel
    add_attributes :service, :action
    add_attribute :type, json_key: '@type'

    def initialize(attributes = {})
      @type = "RestServiceProfile"
      super(attributes)
    end

    def actions
      [*action]
    end
  end
end