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
        param = described_class.new(name: 'param1', variable: 'my.variable.value')
        p = described_class.process_params(param, {'my.variable.value' => 123})
        expect(p['param1']).to eq 123
      end

      it "doesn't replace fixed params" do
        param = described_class.new(name: 'param1', fixed: 'my fixed value')
        p = described_class.process_params(param, {'my.variable.value' => 123})
        expect(p['param1']).to eq 'my fixed value'
      end

      it 'handles fixed and variable params' do
        params = [described_class.new(name: 'param1', fixed: 'my fixed value'),
                  described_class.new(name: 'param2', variable: 'my.variable.value')]
        p = described_class.process_params(params, {'my.variable.value' => 123})
        expect(p['param1']).to eq 'my fixed value'
        expect(p['param2']).to eq 123
      end

      it 'handles lambdas for variables' do
        param = described_class.new(name: 'param1', variable: 'my.variable.value')
        p = described_class.process_params(param, {'my.variable.value' => -> { 123 }})
        expect(p['param1']).to eq 123
      end

      it 'handles procs for variables' do
        param = described_class.new(name: 'param1', variable: 'my.variable.value')
        p = described_class.process_params(param, {'my.variable.value' => Proc.new { 123 } } )
        expect(p['param1']).to eq 123
      end
       it 'returns the variable with a $ prepended if it ca not be expanded' do
         param = described_class.new(name: 'param1', variable: 'my.variable.value')
         p = described_class.process_params(param, {})
         expect(p['param1']).to eq '$my.variable.value'
       end


    end

    describe '#==' do
       it 'is equal when both are fixed and the names and fixed values are the same' do
         subject.name = 'my_name'
         subject.fixed = 'my_fixed_value'
         param = described_class.new(name: subject.name, fixed: subject.fixed)
         expect(subject).to eq param
       end

       it 'is equal when both are variable and the names and variable values are the same' do
         subject.name = 'my_name'
         subject.variable = 'my_variable_value'
         param = described_class.new(name: subject.name, variable: subject.variable)
         expect(subject).to eq param
       end

       it 'is not equal when one is fixed and the other variable' do
         subject.name = 'my_name'
         subject.variable = 'my_variable_value'
         param = described_class.new(name: subject.name, fixed: 'my_fixed_value')
         expect(subject).to_not eq param
       end

       it 'is not equal when both are fixed, the names are the same, and fixed values are different' do
         subject.name = 'my_name'
         subject.fixed = 'my_fixed_value'
         param = described_class.new(name: subject.name, fixed: 'my_other_fixed_value')
         expect(subject).to_not eq param
       end

       it 'is not equal when both are fixed, the names are different, and fixed values are the same' do
         subject.name = 'my_name'
         subject.fixed = 'my_fixed_value'
         param = described_class.new(name: 'my_other_name', fixed: subject.fixed)
         expect(subject).to_not eq param
       end

       it 'is not equal when both are variable, the names are the same, and variable values are different' do
         subject.name = 'my_name'
         subject.variable = 'my_variable_value'
         param = described_class.new(name: subject.name, fixed: 'my_other_variable_value')
         expect(subject).to_not eq param
       end

       it 'is not equal when both are variable, the names are different, and variable values are the same' do
         subject.name = 'my_name'
         subject.variable = 'my_varaible_value'
         param = described_class.new(name: 'my_other_name', fixed: subject.variable)
         expect(subject).to_not eq param
       end

    end



  end
end