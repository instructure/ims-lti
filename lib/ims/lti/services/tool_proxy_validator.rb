module IMS::LTI::Services
  class ToolProxyValidator

    attr_reader :tool_proxy

    def initialize(tool_proxy)
      @tool_proxy = tool_proxy
    end

    def tool_consumer_profile
      return @tool_consumer_profile if @tool_consumer_profile

      connection = Faraday.new
      response = connection.get(tool_proxy.tool_consumer_profile)
      @tool_consumer_profile = IMS::LTI::Models::ToolConsumerProfile.new.from_json(response.body)
      @tool_consumer_profile
    end

    def tool_consumer_profile=(tcp)
      tcp = IMS::LTI::Models::ToolConsumerProfile.from_json(tcp) unless tcp.is_a?(IMS::LTI::Models::ToolConsumerProfile)
      if tool_proxy.tool_consumer_profile != tcp.id
        raise IMS::LTI::Errors::InvalidToolConsumerProfile, "Tool Consumer Profile @id doesn't match the Tool Proxy"
      end
      @tool_consumer_profile = tcp
    end

    def capabilities_offered
      tool_consumer_profile.capabilities_offered
    end

    def invalid_services
      services = tool_proxy.security_contract.services
      services_used = services.each_with_object({}) do |s, hash|
        hash[s.service.split('#').last.strip] = s.actions
        hash
      end
      services_offered = tool_consumer_profile.services_offered.each_with_object({}) do |s, hash|
        hash[s.id.split(':').last.split('#').last.strip] = s.actions
        hash
      end
      invalid_services = services_used.each_with_object({}) do |(id, actions), hash|
        if services_offered.keys.include?(id)
          actions_used = normalize_strings(*services_offered[id])
          actions_offered = normalize_strings(*actions)
          invalid_actions = actions_offered - actions_used
          hash[id] = invalid_actions unless invalid_actions.empty?
        else
          hash[id] = actions
        end
        hash
      end
      invalid_services
    end

    def invalid_message_handlers
      ret_val = {}
      tool_profile = tool_proxy.tool_profile
      #singleton_message_handlers = tool_profile.messages
      invalid_rhs = validate_resource_handlers(tool_profile.resource_handlers)
      ret_val[:resource_handlers] = invalid_rhs unless invalid_rhs.empty?
      invalid_singleton_message_handlers = validate_singleton_message_handlers(tool_profile.messages)
      ret_val[:singleton_message_handlers] = invalid_singleton_message_handlers unless invalid_singleton_message_handlers.empty?
      ret_val
    end

    def invalid_capabilities
      tool_proxy.enabled_capabilities - capabilities_offered
    end

    def invalid_security_contract
      ret_val = {}

      is_split_secret_capable = tool_proxy.enabled_capabilities.include?('OAuth.splitSecret')
      has_shared_secret = tool_proxy.security_contract.shared_secret != nil && !tool_proxy.security_contract.shared_secret.empty?
      has_split_secret = tool_proxy.security_contract.tp_half_shared_secret != nil && !tool_proxy.security_contract.tp_half_shared_secret.empty?

      if is_split_secret_capable
        ret_val[:missing_secret] = :tp_half_shared_secret unless has_split_secret
        ret_val[:invalid_secret_type] = :shared_secret if has_shared_secret
      else
        ret_val[:missing_secret] = :shared_secret unless has_shared_secret
        ret_val[:invalid_secret_type] = :tp_half_shared_secret if has_split_secret
      end

      ret_val
    end

    def errors
      ret_val = {}
      ret_val[:invalid_security_contract] = invalid_security_contract unless invalid_security_contract.empty?
      ret_val[:invalid_capabilities] = invalid_capabilities unless invalid_capabilities.empty?
      ret_val[:invalid_message_handlers] = invalid_message_handlers unless invalid_message_handlers.empty?
      ret_val[:invalid_services] = invalid_services unless invalid_services.empty?

      ret_val
    end

    def valid?
      invalid_capabilities.empty? && invalid_security_contract.empty? && invalid_services.empty? && invalid_message_handlers.empty?
    end

    private

    def normalize_strings(string, *strings)
      strings.push(string)
      normalized = strings.map { |s| s.upcase.strip }
      normalized
    end

    def validate_message_handlers(message_handlers)
      message_handlers.each_with_object([]) do |mh, array|
        invalid_capabilities = mh.enabled_capabilities - capabilities_offered
        invalid_parameters = validate_parameters(mh.parameters)
        if !invalid_parameters.empty? || !invalid_capabilities.empty?
          hash = {message_type: mh.message_type, }
          hash[:invalid_capabilities] = invalid_capabilities unless invalid_capabilities.empty?
          hash[:invalid_parameters] = invalid_parameters unless invalid_parameters.empty?
          array << hash
        end
        array
      end
    end

    def validate_parameters(parameters)
      parameters.each_with_object([]) do |p, array|
        if !p.fixed? && !capabilities_offered.include?(p.variable)
          array << {name: p.name, variable: p.variable}
        end
      end
    end

    def validate_message_types(message_handlers)
      message_handlers.each_with_object([]) do |mh, array|
        array << mh.message_type unless capabilities_offered.include?(mh.message_type)
        array
      end
    end

    def validate_resource_handlers(resource_handlers)
      resource_handlers.each_with_object([]) do |rh, array|
        invalid_message_types = validate_message_types(rh.messages)
        invalid_mhs = validate_message_handlers(rh.messages)
        if !invalid_mhs.empty? || !invalid_message_types.empty?
          hash = {
              code: rh.resource_type.code,
          }
          hash[:messages] = invalid_mhs unless invalid_mhs.empty?
          hash[:invalid_message_types] = invalid_message_types unless invalid_message_types.empty?
          array << hash
        end
        array
      end
    end

    def validate_singleton_message_handlers(message_handlers)
      hash = {}
      invalid_messages = validate_message_handlers(message_handlers)
      invalid_message_types = validate_message_types(message_handlers)
      hash[:messages] = invalid_messages unless invalid_messages.empty?
      hash[:invalid_message_types] = invalid_message_types unless invalid_message_types.empty?
      hash
    end


  end
end