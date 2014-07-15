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
      expect{
        obj = described_class.new(one: 1, two: 2, three: 3)
        expect(obj.instance_variable_get('@one')).to be_nil
        expect(obj.instance_variable_get('@two')).to be_nil
        expect(obj.instance_variable_get('@three')).to be_nil
      }
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

        it 'handels arrays of items' do
          model = SampleClass.new.from_json('{"two": [{"a": "a"}, {"b": "b"}]}')
          expect(model.two.count).to eq 2
        end

      end

    end

  end
end