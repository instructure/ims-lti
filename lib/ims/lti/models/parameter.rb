module IMS::LTI::Models
  class Parameter < LTIModel
    add_attributes :name, :variable, :fixed
  end
end