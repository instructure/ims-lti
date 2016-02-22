module IMS::LTI::Serializers
  class Base
    class Filter
      def initialize
        @optionals = Set.new
        @keys = {}
        @serializables = Set.new
        @serializable_lists = Set.new
      end

      def add_filter(name, opts={})
        @optionals.add(name) if opts[:optional]
        @keys[name] = opts[:key] if opts[:key]
        @serializables.add(name) if opts[:serializable]
        @serializable_lists.add(name) if opts[:list_of_serializables]
      end

      def options_for_attribute(attribute)
        options = {}
        options[:optional] = @optionals.include?(attribute) ? true : false
        options[:key] = @keys[attribute]
        options[:has_serializable] = @serializables.include?(attribute) ? true : false
        options[:has_list_of_serializables] = @serializable_lists.include?(attribute) ? true : false
        options
      end

      def filter(hash)
        hash = optionals(hash)
        hash = serializables(hash)
        hash = serializable_lists(hash)
        keys(hash) # Needs to happen last
      end

      private
      def optionals(hash)
        hash.reject { |k, v| @optionals.include?(k) && v.nil? }
      end

      def serializables(hash)
        hash.reduce({}) do |memo, (k, v)|
          memo[k] = @serializables.include?(k) ? serialize_serializable(v) : v
          memo
        end
      end

      def serialize_serializable(serializable)
        return if serializable.nil?
        serializable.as_json
      end

      def serializable_lists(hash)
        hash.reduce({}) do |memo, (k, v)|
          memo[k] = @serializable_lists.include?(k) ? serialize_serializable_list(v) : v
          memo
        end
      end

      def serialize_serializable_list(list)
        return if list.nil?
        list.map(&:as_json)
      end

      def keys(hash)
        hash.reduce({}) do |memo, (k, v)|
          key = @keys.include?(k) ? @keys[k] : k
          memo[key] = v
          memo
        end
      end
    end

    @filter = Filter.new
    @attributes = Set.new

    def self.inherited(subclass)
      subclass.instance_variable_set(:@filter, Filter.new)
      subclass.instance_variable_set(:@attributes, Set.new)
    end

    def self.set_attribute(name, opts={})
      @attributes.add(name)
      @filter.add_filter(name, opts)
    end

    def self.set_attributes(*names)
      names.each { |name| set_attribute(name) }
    end

    def self.has_serializable(name, opts={})
      opts[:serializable] = true
      opts[:list_of_serializables] = false
      set_attribute(name, opts)
    end

    def self.has_list_of_serializables(name, opts={})
      opts[:list_of_serializables] = true
      opts[:serializable] = false
      set_attribute(name, opts)
    end

    def self.as_json(obj)
      @filter.filter(base_hash(obj))
    end

    def self.to_json(obj)
      as_json(obj).to_json
    end

    def self.options_for_attribute(attribute)
      @filter.options_for_attribute(attribute)
    end

    def self.attributes
      @attributes
    end

    private

    def self.base_hash(obj)
      h = {}
      @attributes.each { |attribute| h[attribute] = obj.send(attribute) }
      h
    end
  end
end
