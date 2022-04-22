require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::PowerBase do
  describe ".initialize" do
    subject(:formula) { Plurimath::Math::Function::PowerBase.new(first, second) }
    context "initialize PowerBase object"
      it 'returns instance of PowerBase' do
        let(:first) { "sum" }
        let(:second) { "theta" }
        power_base = Plurimath::Math::Function::PowerBase.new("sum", "theta")
        expect(power_base).to be_a(Plurimath::Math::Function::PowerBase)
      end

      it 'initializes PowerBase object' do
        power_base = Plurimath::Math::Function::PowerBase.new("sum", "theta", "square")
        expect(power_base.parameter_one).to eql("sum")
        expect(power_base.parameter_two).to eql("theta")
        expect(power_base.parameter_three).to eql("square")
      end
    end
  end
end
