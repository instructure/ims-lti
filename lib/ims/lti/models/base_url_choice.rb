module IMS::LTI::Models
  class BaseUrlChoice < LTIModel
    add_attributes :default_base_url, :secure_base_url
    add_attribute :selector, relation:'IMS::LTI::Models::BaseUrlSelector'

    def default_message_url
      if selector.nil? || (selector.applies_to && selector.applies_to.include?('MessageHandler'))
        secure_base_url || default_base_url || ''
      else
        ''
      end
    end

  end
end