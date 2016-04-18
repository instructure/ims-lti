module IMS::LTI::Errors
  class ToolProxyRegistrationError < StandardError
    attr_reader :response_status, :response_body

    def initialize(response_status, response_body = nil)
      @response_status = response_status
      @response_body = response_body
      super <<-EOF
Unexpected response for tool proxy registration.
HTTP Response Status: #{response_status}
HTTP Response Body: #{response_body}
EOF
    end
  end
end
