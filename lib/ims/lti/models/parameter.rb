module IMS::LTI::Models
  class Parameter < LTIModel
    add_attributes :name, :variable, :fixed

    def fixed?
      !fixed.nil? && fixed.strip != ''
    end

    def self.process_params(parameters, lookup_hash)
      [*parameters].inject({}) do |hash, param|
        hash[param.name] = param.fixed? ? param.fixed : expand_variable(lookup_hash[param.variable])
        hash
      end
    end

    private

    def self.expand_variable(value)
      value.respond_to?(:call) ? value.call : value
    end

  end
end