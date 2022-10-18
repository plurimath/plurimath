require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::PowerBase do
  describe ".initialize" do
    subject(:power_base) { Plurimath::Math::Function::PowerBase.new(first, second, third) }

    context "initialize PowerBase object" do
      let(:first) { Plurimath::Math::Function::Sum.new }
      let(:second) { Plurimath::Math::Symbol.new("Theta") }
      let(:third) { Plurimath::Math::Symbol.new("square") }

      it 'returns instance of PowerBase' do
        expect(power_base).to be_a(Plurimath::Math::Function::PowerBase)
      end

      it 'initializes PowerBase object' do
        expect(power_base.parameter_one).to eq(Plurimath::Math::Function::Sum.new)
        expect(power_base.parameter_two).to eq(Plurimath::Math::Symbol.new("Theta"))
        expect(power_base.parameter_three).to eq(Plurimath::Math::Symbol.new("square"))
      end
    end
  end

  describe ".to_asciimath" do
    subject(:power_base) { Plurimath::Math::Function::PowerBase.new(first, second, third).to_asciimath }

    context "contains PowerBase object" do
      let(:first) { Plurimath::Math::Function::Sum.new }
      let(:second) { Plurimath::Math::Symbol.new("Theta") }
      let(:third) { Plurimath::Math::Symbol.new("square") }

      it 'returns asciimath string' do
        expect(power_base).to eq("sum_Theta^square")
      end

      it 'not returns asciimath string' do
        expect(power_base).not_to eq("sum_theta^square")
      end
    end
  end

  describe ".==" do
    subject(:power_base) { Plurimath::Math::Function::PowerBase.new(first, second, third) }

    context "contains PowerBase object" do
      let(:first) { Plurimath::Math::Function::Sum.new }
      let(:second) { Plurimath::Math::Symbol.new("Theta") }
      let(:third) { Plurimath::Math::Symbol.new("square") }

      it 'matches epxected value' do
        expected_value = Plurimath::Math::Function::PowerBase.new(
          Plurimath::Math::Function::Sum.new,
          Plurimath::Math::Symbol.new("Theta"),
          Plurimath::Math::Symbol.new("square"),
        )
        expect(power_base).to eq(expected_value)
      end

      it 'matches epxected value' do
        expected_value = Plurimath::Math::Function::PowerBase.new(
          Plurimath::Math::Function::Sum.new,
          Plurimath::Math::Symbol.new("theta"),
          Plurimath::Math::Symbol.new("square"),
        )
        expect(power_base).not_to eq(expected_value)
      end
    end
  end
end
