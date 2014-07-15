module IMS::LTI::Models
  class RestService < LTIModel
    TYPE = 'RestService'

    add_attributes :endpoint, :format, :action
    add_attribute :id, json_key:'@id'
    add_attribute :type, json_key: '@type'

    def initialize
      @type = TYPE
    end

  end
end