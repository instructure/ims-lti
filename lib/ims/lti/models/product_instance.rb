module IMS::LTI::Models
  class ProductInstance < LTIModel
    add_attributes :guid
    add_attribute :product_info, relation:'IMS::LTI::Models::ProductInfo'
    add_attribute :service_owner, relation:'IMS::LTI::Models::ServiceOwner'
    add_attribute :service_provider, relation:'IMS::LTI::Models::ServiceProvider'
    add_attribute :support, relation:'IMS::LTI::Models::Contact'

  end
end