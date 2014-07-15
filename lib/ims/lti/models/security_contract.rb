module IMS::LTI::Models
  class SecurityContract < LTIModel

    add_attribute :shared_secret
    add_attribute :tool_service, relation: 'IMS::LTI::Models::RestServiceProfile'
    add_attribute :end_user_service, relation: 'IMS::LTI::Models::RestServiceProfile'

  end
end