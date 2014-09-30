module IMS::LTI::Models
  class LocalizedName < LTIModel
    add_attributes :default_value, :key

    def initialize(default_value = nil, key = nil)
      @default_value = default_value
      @key = key
      super()
    end

  end
end