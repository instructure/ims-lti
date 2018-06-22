require 'active_model'

module Ims::Lti::Claims
  class Extension
    include ActiveModel::Model

    attr_accessor :claim_name,
                  :claim_value
  end
end