module IMS::LTI::Models
  module MembershipService
    require_relative 'membership_service/agent'
    require_relative 'membership_service/person'
    require_relative 'membership_service/lis_person'

    require_relative 'membership_service/container'
    require_relative 'membership_service/lis_membership_container'

    require_relative 'membership_service/organization'
    require_relative 'membership_service/context'

    require_relative 'membership_service/membership'
    require_relative 'membership_service/page'
  end
end
