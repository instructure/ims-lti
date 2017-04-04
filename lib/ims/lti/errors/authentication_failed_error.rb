module IMS::LTI::Errors
  class AuthenticationFailedError < StandardError

    attr_reader :response

    def initialize(response: nil)
      @response = response
    end

  end
end