require 'spec_helper'

module IMS::LTI::Models
  describe Parameter do

    describe '#fixed?' do

      it 'returns true if the value is fixed' do
        subject.fixed = 'my_fixed_value'
        expect(subject.fixed?).to eq true
      end

      it 'returns false if the value is variable' do
        subject.variable = 'my_variable'
        expect(subject.fixed?).to eq false
      end

    end

    describe '#self.process_params' do
      it 'replaces variable params' do
        param = described_class.new(name: 'param1', variable: '$my.variable.value')
        p = described_class.process_params(param, {'$my.variable.value' => 123})
        expect(p['param1']).to eq 123
      end

      it "doesn't replace fixed params" do
        param = described_class.new(name: 'param1', fixed: 'my fixed value')
        p = described_class.process_params(param, {'$my.variable.value' => 123})
        expect(p['param1']).to eq 'my fixed value'
      end

      it 'handles fixed and variable params' do
        params = [described_class.new(name: 'param1', fixed: 'my fixed value'),
                  described_class.new(name: 'param2', variable: '$my.variable.value')]
        p = described_class.process_params(params, {'$my.variable.value' => 123})
        expect(p['param1']).to eq 'my fixed value'
        expect(p['param2']).to eq 123
      end

      it 'handles lambdas for variables' do
        param = described_class.new(name: 'param1', variable: '$my.variable.value')
        p = described_class.process_params(param, {'$my.variable.value' => -> { 123 }})
        expect(p['param1']).to eq 123
      end

      it 'handles procs for variables' do
        param = described_class.new(name: 'param1', variable: '$my.variable.value')
        p = described_class.process_params(param, {'$my.variable.value' => Proc.new { 123 } } )
        expect(p['param1']).to eq 123
      end

    end


  end
end