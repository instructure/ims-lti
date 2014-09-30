module IMS::LTI::Models
  class LocalizedText < LTIModel
    add_attributes :default_value, :key

    def initialize(default_value = nil, key = nil)
      super()
      @default_value = default_value
      @key = key
    end

  end
end