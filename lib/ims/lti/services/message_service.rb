module IMS::LTI::Services
  class MessageService

    def initialize(launch_url, params)
      @launch_url = launch_url
      @params = params
    end

    def message
      @message ||= begin
        m = IMS::LTI::Models::Messages::Message.generate(@params)
        m.launch_url = @launch_url
        m
      end
    end

  end
end