require 'spec_helper'

module IMS::LTI::Models
  describe LTIModel do

    it 'can initilize with a hash' do
      described_class.add_attributes(:one, :two)
      obj = described_class.new(one: 1, two: 2)
      expect(obj.one).to eq 1
      expect(obj.two).to eq 2
    end

    it 'when initialized with unsupported attributes' do
      #swallow warning
      expect {
        obj = described_class.new(one: 1, two: 2, three: 3)
        expect(obj.instance_variable_get('@one')).to be_nil
        expect(obj.instance_variable_get('@two')).to be_nil
        expect(obj.instance_variable_get('@three')).to be_nil
      }
    end

    it 'stores unknown attributes' do
      obj = described_class.new(foo: 1)
      expect(obj.foo).to eq 1
    end

    describe 'inherited attributes' do

      class A < described_class
        add_attribute :aisle
      end

      class B < A
        add_attribute :bdellium
      end

      class C < B
        add_attribute :czar
      end

      it 'collects the attributes from all the parent classes' do
        c = C.new
        c.aisle = 'a'
        c.bdellium = 'b'
        c.czar = 'c'
        expect(c.attributes).to eq({'aisle' => 'a', 'bdellium' => 'b', 'czar' => 'c'})
      end

    end

    describe 'add_attribute' do
      class A < described_class
        add_attribute :aisle
      end
      it 'only lets you set an attribute once' do
        A.add_attribute :one
        A.add_attribute :one
        expect(A.attributes.select { |k| k == :one }.size).to eq 1
      end

      it 'only takes the last options set for the attribute' do
        A.add_attribute :one, json_key: 'one'
        A.add_attribute :one
        ser_options = A.instance_variable_get(:'@serialization_options')
        expect(ser_options.map { |_, v| v.keys }.flatten.select { |k| k == :one }.size).to eq 0
      end

    end

    describe "#add_attributes" do
      it 'adds attributes' do
        described_class.add_attributes(:one)
        model = described_class.new
        model.one = 1
        expect(model.one).to eq 1
      end

      it 'returns attributes' do
        described_class.add_attributes(:one, :two)
        model = described_class.new
        model.one = 1
        model.two = 2
        expect(model.attributes).to eq({"one" => 1, "two" => 2})
      end

      it 'sets attributes' do
        described_class.add_attributes(:one, :two)
        model = described_class.new
        model.attributes = {'one' => 1, 'two' => 2}
        expect(model.one).to eq 1
        expect(model.two).to eq 2
      end

      it 'sets attributes from symbol' do
        described_class.add_attributes(:one, :two)
        model = described_class.new
        model.attributes = {one: 1, two: 2}
        expect(model.one).to eq 1
        expect(model.two).to eq 2
      end

      it 'only sets the attributes sent' do
        described_class.add_attributes(:one, :two)
        model = described_class.new
        model.two = 2
        model.attributes = {one: 1}
        expect(model.one).to eq 1
        expect(model.two).to eq 2
      end

      it 'only lets you set an attribute once' do
        described_class.add_attributes :one
        described_class.add_attributes :one
        expect(described_class.attributes.select { |k| k == :one }.size).to eq 1
      end

    end

    describe 'attributes' do

      class Two < described_class
        add_attribute :a
      end

      class FortyTwoConverter
        def self.to_json_value(val)
          42
        end

        def self.from_json_value(val)
          42
        end
      end

      class SampleClass < described_class
        add_attribute :uno
        add_attribute :one, json_key: '@one'
        add_attribute :two, relation: 'IMS::LTI::Models::Two'
        add_attribute :three, json_converter: 'IMS::LTI::Models::FortyTwoConverter'
        add_attribute :four, json_converter: 'IMS::LTI::Models::FortyTwoConverter', json_key: '@four'
      end

      it 'creates an attribute with no options' do
        model = SampleClass.new
        model.uno = 1
        expect(model.uno).to eq 1
      end

      describe '#as_json' do
        it 'serializes to custom json keys' do
          model = SampleClass.new
          model.one = 'one'
          json = model.as_json
          expect(json['@one']).to eq 'one'
        end

        it 'serializes relations' do
          model = SampleClass.new
          two = Two.new
          two.a = 'a'
          model.two = two
          json = model.as_json
          expect(json['two']['a']).to eq 'a'
        end

        it 'converts attributes' do
          model = SampleClass.new
          model.three = 'what is the answer to life the universe and everything?'

          expect(FortyTwoConverter).to receive(:to_json_value).with("what is the answer to life the universe and everything?").and_return(42)
          json = model.as_json
          expect(json['three']).to eq 42
        end

        it 'handles conversions, and json keys' do
          model = SampleClass.new
          model.four = 'what is the answer to life the universe and everything?'

          expect(FortyTwoConverter).to receive(:to_json_value).with("what is the answer to life the universe and everything?").and_return(42)
          json = model.as_json
          expect(json['@four']).to eq 42
        end

        it 'handles nil json_key values' do
          model = SampleClass.new
          expect(model.as_json.keys).to_not include '@one'
        end

      end

      describe '#from_json' do

        it 'deserializes json with json key mappings' do
          model = SampleClass.new.from_json('{"@one":1}')
          expect(model.one).to eq 1
        end

        it 'deserializes json with relations' do
          model = SampleClass.new.from_json('{"two": {"a": "a"}}')
          expect(model.two.a).to eq 'a'
        end

        it 'converts json values back to ruby objects' do
          expect(FortyTwoConverter).to receive(:from_json_value).with("what is the answer to life the universe and everything?").and_return(42)
          model = SampleClass.new.from_json('{"three": "what is the answer to life the universe and everything?"}')
          expect(model.three).to eq 42
        end

        it 'handles conversions and json keys' do
          expect(FortyTwoConverter).to receive(:from_json_value).with("what is the answer to life the universe and everything?").and_return(42)
          model = SampleClass.new.from_json('{"@four": "what is the answer to life the universe and everything?"}')
          expect(model.four).to eq 42
        end

        it 'should only convert things in the json' do
          model = SampleClass.new.from_json('{"@one":1}')
          expect(model.attributes.values).to eq [1]
        end

        it 'handles arrays of items' do
          model = SampleClass.new.from_json('{"two": [{"a": "a"}, {"a": "b"}]}')
          expect(model.two.count).to eq 2
        end

        context "inherited class" do

          class TestSubclass < SampleClass
            add_attribute :dos
            add_attribute :tres, json_key: @tres
          end

          it 'handles subclassing' do
            model = TestSubclass.new.from_json('{"@one":1, "two": {"a": "a"}}')
            expect(model.one).to eq 1
            expect(model.two.a).to eq 'a'
          end

          it 'lets you add methods ad-hoc to parent classes' do
            SampleClass.add_attribute :sample
            obj = TestSubclass.new(sample: '123')
            expect(obj.as_json).to eq({"sample" => '123'})
          end

        end

      end

      describe '#self.from_json' do

        it 'deserializes json with json key mappings' do
          model = SampleClass.from_json('{"@one":1}')
          expect(model.one).to eq 1
        end

        it 'handles arrays of items' do
          model = SampleClass.from_json('{"two": [{"a": "a"}, {"a": "b"}]}')
          expect(model.two.count).to eq 2
        end

      end

      context 'ext_ methods' do

        it 'pareses ext_ json' do
          obj = SampleClass.from_json({ext_custom_field: 123}.to_json)
          expect(obj.instance_variable_get('@ext_attributes')).to eq({ext_custom_field: 123})
        end

        it 'convert ext_ attributes back to json' do
          obj = SampleClass.new
          obj.instance_variable_set('@ext_attributes', {ext_custom_field: 456})
          expect(obj.to_json).to eq '{"ext_custom_field":456}'
        end

        it 'sets ext_ attributes via method call' do
          obj = SampleClass.new
          obj.ext_custom_field = 789
          expect(obj.instance_variable_get('@ext_attributes')).to eq({ext_custom_field: 789})
        end

        it 'returns ext_ attributes via method call' do
          obj = SampleClass.new
          obj.instance_variable_set('@ext_attributes', {ext_custom_field: 456})
          expect(obj.ext_custom_field).to eq 456
        end


      end

      context 'unknown methods' do

        it 'parses unknown json' do
          obj = SampleClass.from_json({unknown_custom_field: 123}.to_json)
          expect(obj.unknown_custom_field).to eq 123
        end

        it 'convert unknown attributes back to json' do
          obj = SampleClass.new(unknown_custom_field: 456)
          expect(obj.to_json).to eq '{"unknown_custom_field":456}'
        end

        it 'sets/gets unknown attributes via method call' do
          obj = SampleClass.new
          obj.unknown_custom_field = 789
          expect(obj.unknown_custom_field).to eq 789
        end

      end

    end

  end
end