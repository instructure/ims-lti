module IMS::LTI::Models
  class LTIModel
    LTI_VERSION_2P0 = 'LTI-2p0'

    def initialize(attributes = {})
      self.attributes = attributes
    end

    def self.add_attributes(attribute, *attrs)
      attrs.unshift(attribute)
      self.attributes += attrs
      attr_accessor(attrs.shift, *attrs)
    end

    def self.add_attribute(attribute, options = {})
      @serialization_options ||= {}
      options.each do |k, v|
        @serialization_options[k] ||= {}
        @serialization_options[k][attribute] = v
      end
      self.attributes += [attribute]
      attr_accessor(attribute)
    end

    def self.inherit_attributes(attrs)
      attributes ||= []
      self.attributes += attrs
    end

    def self.inherited(subclass)
      subclass.inherit_attributes(self.attributes)
    end

    def attributes
      attrs = {}
      self.class.attributes.each do |a|
        value = instance_variable_get("@#{a.to_s}")
        attrs[a.to_s] = value unless value == nil
      end
      attrs
    end

    def attributes=(attrs)
      attrs.each do |k, v|
        if self.class.attributes.include?(k.to_sym)
          instance_variable_set("@#{k.to_s}", v)
        else
          warn("Unknown attribute '#{k}'")
        end
      end
    end

    def as_json(options = {})
      json_hash = attributes
      serialization_attrs_for(:json_key).each { |attr| json_hash.delete(attr.to_s) }
      serialization_attrs_for(:relation).each do |attr|
        val = attributes[attr.to_s]
        json_hash[json_key(attr)] = val.as_json if val
      end
      json_hash.merge! to_json_conversions
      json_hash.merge! to_json_keys
      json_hash
    end

    def to_json
      self.as_json.to_json
    end

    def from_json(json)
      data = JSON.parse(json)
      if data.is_a? Array
        data.map { |hash| self.class.new.from_json(hash.to_json) }
      else
        process_json_hash(data)
      end
    end

    private

    def process_json_hash(hash)
      change_json_keys_to_attrs!(hash)
      hash.merge! from_json_conversions(hash)
      deserialize_json_relations!(hash)
      self.attributes=(hash)
      self
    end

    def serialization_attrs_for(*keys)
      Array.new(serialization_options.keys & keys).map { |opt| serialization_options[opt].keys }.flatten.uniq
    end

    def to_json_conversions
      result = {}
      if converters = serialization_options[:json_converter]
        converters.each do |attr, converter|
          value = attributes[attr.to_s]
          result[json_key(attr)] = get_constant(converter).to_json_value(value) if value
        end
      end
      result
    end

    def to_json_keys
      result = {}
      if attrs = serialization_attrs_for(:json_key)
        conversion_attrs = serialization_attrs_for(:json_converter)
        attrs.each { |attr| result[json_key(attr)] = attributes[attr.to_s] unless conversion_attrs.include?(attr) || attributes[attr.to_s].nil? }
      end
      result
    end

    def change_json_keys_to_attrs!(json_hash)
      if attrs = serialization_attrs_for(:json_key)
        attrs.each do |attr|
          key = json_key(attr)
          json_hash[attr.to_s] = json_hash.delete(key) if json_hash.has_key?(key)
        end
      end
    end

    def from_json_conversions(hash)
      result = {}
      if converters = serialization_options[:json_converter]
        converters.each do |attr, converter|
          result[attr] = get_constant(converter).from_json_value(hash[attr.to_s]) if hash[attr.to_s]
        end
      end
      result
    end

    def deserialize_json_relations!(hash)
      if relations = serialization_options[:relation]
        attrs = {}
        relations.each do |attr, relation|
          hash_val = hash.delete(attr.to_s)
          attrs[attr.to_s] = get_constant(relation).new.from_json(hash_val.to_json) if hash_val
        end
        self.attributes = attrs
      end
    end

    def json_key(attr)
      if json_keys = serialization_options[:json_key]
        json_keys[attr] || attr
      else
        attr
      end.to_s
    end

    def self.attributes
      @attributes || []
    end

    def self.attributes=(attribs)
      @attributes = attribs
    end

    def self.serialization_options
      @serialization_options ||= {}
    end

    def serialization_options
      self.class.serialization_options
    end

    def get_constant(constant)
      obj = Object
      constant.split('::').each { |c| obj = obj.const_get(c) }
      obj
    end

  end
end