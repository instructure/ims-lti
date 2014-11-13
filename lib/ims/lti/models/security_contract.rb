module IMS::LTI::Models
  class SecurityContract < LTIModel

    add_attribute :shared_secret
    add_attribute :tool_service, relation: 'IMS::LTI::Models::RestServiceProfile'
    add_attribute :end_user_service, relation: 'IMS::LTI::Models::RestServiceProfile'

    def tool_services
      [*tool_service]
    end

    def end_user_services
      [*end_user_service]
    end

    def services
      tool_services + end_user_services
    end

  end
end