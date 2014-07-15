module IMS::LTI::Converters
  class TimeJSONConverter

    def self.to_json_value(time)
      time
    end

    def self.from_json_value(json_val)
      Time.parse(json_val)
    end

  end
end