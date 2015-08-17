module IMS::LTI::Errors
  class ToolProxyRegistrationError < StandardError
    attr_reader :response_status, :response_body

    def initialize(response_status, response_body = nil)
      @response_status = response_status
      @response_body = response_body
    end

  end
end
