require 'spec_helper'

class Serializer < IMS::LTI::Serializers::Base
  set_attributes :field1, :field2
  set_attribute :field3, key: :@field3
  set_attribute :field4, optional: true
  set_attribute :field5, key: :@field5, optional: true
  has_serializable :field6, key: :@field6
  has_list_of_serializables :field7, optional: true
  has_list_of_serializables :field8
end

class Serializable
  attr_reader :field1, :field2, :field3, :field4, :field5, :field6, :field7, :field8

  def initialize(opts={})
    @field1 = opts[:field1]
    @field2 = opts[:field2]
    @field3 = opts[:field3]
    @field4 = opts[:field4]
    @field5 = opts[:field5]
    @field6 = opts[:field6]
    @field7 = opts[:field7]
    @field8 = opts[:field8]
  end

  def as_json(opts={})
    { foo: :bar, bar: :foo }
  end
end

module IMS::LTI::Serializers
  describe Base do
    describe '.as_json' do
      context 'with an object that has values for all fields' do
        let(:obj) do
          Serializable.new({
            field1: 1,
            field2: 2,
            field3: 3,
            field4: 4,
            field5: 5,
            field6: Serializable.new,
            field7: [Serializable.new, Serializable.new]
          })
        end

        let(:output) { Serializer.as_json(obj) }

        it 'outputs attributes added using .attributes' do
          expect(output[:field1]).to eq 1
          expect(output[:field2]).to eq 2
        end

        it 'outputs a custom key' do
          expect(output[:@field3]).to eq 3
        end

        it 'outputs an optional attribute' do
          expect(output[:field4]).to eq 4
        end

        it 'outputs a custom key for an optional attribute' do
          expect(output[:@field5]).to eq 5
        end

        it 'outputs a serialized serializable with a custom key' do
          expect(output[:@field6]).to eq({ foo: :bar, bar: :foo })
        end

        it 'outputs a serialized list of serializables for an optional attribute' do
          expected = [{ foo: :bar, bar: :foo }, { bar: :foo, foo: :bar }]
          expect(output[:field7]).to match_array expected
        end
      end

      context 'with an object that has no values for all fields' do
        let(:obj) do
          Serializable.new({
            field1: nil,
            field2: nil,
            field3: nil,
            field4: nil,
            field5: nil,
            field6: nil,
            field7: nil
          })
        end

        let(:output) { Serializer.as_json(obj) }

        it 'outputs non-optional fields' do
          expect(output.size).to eq 5
          expect(output.key?(:field1)).to eq true
          expect(output[:field1]).to be_nil
          expect(output.key?(:field2)).to eq true
          expect(output[:field2]).to be_nil
          expect(output.key?(:@field3)).to eq true
          expect(output[:@field3]).to be_nil
          expect(output.key?(:@field6)).to eq true
          expect(output[:@field6]).to be_nil
          expect(output.key?(:field8)).to eq true
          expect(output[:field8]).to be_nil
        end

        it 'does not output optional fields' do
          expect(output.key?(:field4)).to eq false
          expect(output.key?(:@field5)).to eq false
          expect(output.key?(:field7)).to eq false
        end
      end
    end

    describe '.to_json' do
      let(:obj) do
        Serializable.new({
          field1: 1,
          field2: 2,
          field3: 3,
          field4: nil,
          field5: nil,
          field6: Serializable.new,
          field7: nil,
          field8: [Serializable.new]
        })
      end

      it 'outputs valid json' do
        json = Serializer.to_json(obj)
        expected = {
          :field1 => 1,
          :field2 => 2,
          :@field3 => 3,
          :@field6 => { :foo => :bar, :bar => :foo },
          :field8 => [{ :foo => :bar, :bar => :foo }]
        }.to_json
        expect(json).to eq(expected)
      end
    end

    describe '.attributes' do
      it 'returns a list of configured attributes' do
        attributes = [:field1, :field2, :field3, :field4, :field5, :field6, :field7, :field8]
        expect(Serializer.attributes).to match_array(attributes)
      end
    end

    describe '.options_for_attribute' do
      it 'returns the options for an option added with .attributes' do
        options = Serializer.options_for_attribute(:field1)
        expected_options = {
          optional: false,
          key: nil,
          has_serializable: false,
          has_list_of_serializables: false
        }
        expect(options).to eq expected_options

      end

      it 'returns the options for an attribute added with .set_attribute' do
        options = Serializer.options_for_attribute(:field5)
        expected_options = {
          optional: true,
          key: :@field5,
          has_serializable: false,
          has_list_of_serializables: false
        }
        expect(options).to eq expected_options
      end

      it 'returns the options for an attribute added with .has_serializable' do
        options = Serializer.options_for_attribute(:field6)
        expected_options = {
          optional: false,
          key: :@field6,
          has_serializable: true,
          has_list_of_serializables: false
        }
        expect(options).to eq expected_options
      end

      it 'returns the options for an attribute added with .has_list_of_serializables' do
        options = Serializer.options_for_attribute(:field7)
        expected_options = {
          optional: true,
          key: nil,
          has_serializable: false,
          has_list_of_serializables: true
        }
        expect(options).to eq expected_options
      end
    end
  end
end
