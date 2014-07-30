module IMS::LTI::Models
  class RestService < LTIModel
    TYPE = 'RestService'

    add_attributes :endpoint, :format, :action
    add_attribute :id, json_key:'@id'
    add_attribute :type, json_key: '@type'

    def initialize(attributes = {})
      @type = TYPE
      super(attributes)
    end

    def profile
      RestServiceProfile.new(
          service: endpoint,
          action: action
      )
    end

    def actions
      [*action]
    end

    def formats
      [*format]
    end

  end
end