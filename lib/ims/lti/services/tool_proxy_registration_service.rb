module IMS::LTI::Services
  class ToolProxyRegistrationService
    def initialize(registration_request)
      @registration_request = registration_request
    end

    def tool_consumer_profile
      return @tool_consumer_profile if @tool_consumer_profile

      connection = Faraday.new
      response = connection.get(@registration_request.tc_profile_url)
      @tool_consumer_profile = IMS::LTI::Models::ToolConsumerProfile.new.from_json(response.body)
    end

    def service_profiles
      tool_consumer_profile.services_offered.map(&:profile)
    end

    def register_tool_proxy(tool_proxy)
      service = tool_consumer_profile.services_offered.find{|s| s.formats.include?('application/vnd.ims.lti.v2.toolproxy+json') && s.actions.include?('POST')}

      conn = Faraday.new do |conn|
        conn.request :oauth, consumer_key: @tool_consumer_profile.reg_key, consumer_secret: @tool_consumer_profile.reg_password
        conn.adapter :net_http
      end

      response = conn.post do |req|
        req.url service.endpoint
        req.headers['Content-Type'] = 'application/json'
        req.body = tool_proxy.to_json
      end

      if response.status == 201
        IMS::LTI::Models::ToolProxy.new.from_json(tool_proxy.to_json).from_json(response.body)
      end
    end

  end
end