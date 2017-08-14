module IMS::LTI::Errors
  class AuthenticationFailedError < StandardError

    attr_reader :response, :assertion, :grant_type

    def initialize(response: nil, assertion: nil)
      @response = response
      @assertion = assertion
      @grant_type
    end

  end
end