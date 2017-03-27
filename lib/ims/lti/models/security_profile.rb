module IMS::LTI::Models
  class SecurityProfile < LTIModel
    add_attributes :security_profile_name, :digest_algorithm
  end
end
