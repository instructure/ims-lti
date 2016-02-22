require 'spec_helper'

module IMS::LTI::Models
  class Foo
    include IMS::LTI::Models::Serializable
    attr :field1

    def initialize(opts={})
      @field1 = opts[:field1] || 1
    end
  end
end

module IMS::LTI::Serializers
  class FooSerializer < IMS::LTI::Serializers::Base
    set_attributes :field1
  end
end

module IMS::LTI::Models
  describe Serializable do
    let(:obj) { Foo.new }

    describe '#as_json' do
      it 'serializes objects that have a defined serializer' do
        serialization = obj.as_json
        expect(serialization).to eq({ field1: 1 })
      end
    end

    describe '#to_json' do
      it 'stringifies objects that have a defined serializer' do
        stringification = obj.to_json
        expect(stringification).to eq({ field1: 1 }.to_json)
      end
    end
  end
end
