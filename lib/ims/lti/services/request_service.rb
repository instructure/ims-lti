module IMS::LTI::Services
  class RequestServiceError < StandardError
  end

  class RequestService
    SUPPORTED_METHODS = %i[get post put delete].freeze

    def initialize(headers: nil, body: nil, params: nil)
      @headers = headers
      @body = body
      @params = params
    end

    SUPPORTED_METHODS.each do |method|
      define_method(method) { |url| send_request(method, url) }
    end

    def send_request(method, url)
      method = method.to_s.downcase.to_sym
      unless connection.respond_to? method
        raise RequestServiceError, 'Unrecognized request method'
      end

      response = connection.send(method) do |req|
        req.headers = @headers
        req.params = @params
        req.body = @body.to_s
        req.url url
      end

      response
    end

    private

    def connection
      @_connection ||= Faraday.new do |conn|
        conn.adapter :net_http
      end
    end
  end
end
