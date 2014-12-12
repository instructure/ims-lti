module IMS::LTI::Models
  class ProductInfo < LTIModel
    add_attribute :product_version
    add_attribute :product_family, relation: 'IMS::LTI::Models::ProductFamily'
    add_attribute :description, relation: 'IMS::LTI::Models::LocalizedText'
    add_attribute :product_name, relation: 'IMS::LTI::Models::LocalizedName'
    add_attribute :technical_description, relation: 'IMS::LTI::Models::LocalizedText'

    def create_product_name(name, key = 'product.name')
      @product_name = LocalizedName.new(name, key)
    end

    def create_description(name, key = 'product.description')
      @description = LocalizedText.new(name, key)
    end

    def default_description
      description && description.default_value
    end

    def default_name
      product_name && product_name.default_value
    end

  end
end