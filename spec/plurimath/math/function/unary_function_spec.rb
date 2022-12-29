require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::UnaryFunction do

  it 'returns instance of UnaryFunction' do
    unary_function = Plurimath::Math::Function::UnaryFunction.new("sum")
    expect(unary_function).to be_a(Plurimath::Math::Function::UnaryFunction)
  end

  it 'initializes UnaryFunction object' do
    unary_function = Plurimath::Math::Function::UnaryFunction.new("sum")
    expect(unary_function.parameter_one).to eql("sum")
  end

  describe ".to_asciimath" do
    subject(:formula) { Plurimath::Math::Function::UnaryFunction.new(first_value) }

    context "contains sum fuction" do
      let(:first_value) { Plurimath::Math::Function::Sum.new }
      it "returns asciimath string" do
        expect(formula.to_asciimath).to eq("unaryfunction(sum)")
      end
    end
  end

  describe ".==" do
    subject(:formula) { Plurimath::Math::Function::UnaryFunction.new(first_value) }

    context "contains sum fuction" do
      let(:first_value) { Plurimath::Math::Function::Sum.new }
      expected_value = Plurimath::Math::Function::UnaryFunction.new(
                        Plurimath::Math::Function::Sum.new
                      )
      it "returns true" do
        expect(formula == expected_value).to be_truthy
      end
    end

    context "contains nil unaryfunction" do
      let(:first_value) { nil }
      expected_value = Plurimath::Math::Function::UnaryFunction.new(nil)
      it "returns true" do
        expect(formula == expected_value).to be_truthy
      end
    end

    context "contains sum fuction" do
      let(:first_value) { Plurimath::Math::Function::Sum.new }
      expected_value = Plurimath::Math::Function::UnaryFunction.new(
                        Plurimath::Math::Function::Sum.new
                      )
      it "returns true" do
        expect(formula == expected_value).to be_truthy
      end
    end

    context "contains symbols fuction" do
      let(:first_value) { Plurimath::Math::Symbol.new("Theta") }
      expected_value = Plurimath::Math::Function::UnaryFunction.new(
                        Plurimath::Math::Symbol.new("theta")
                      )
      it "returns false" do
        expect(formula == expected_value).to be_falsey
      end
    end

    context "contains symbols fuction" do
      let(:first_value) { Plurimath::Math::Symbol.new("square") }
      expected_value = Plurimath::Math::Function::UnaryFunction.new(
                        Plurimath::Math::Symbol.new("theta")
                      )
      it "returns false" do
        expect(formula == expected_value).to be_falsey
      end
    end
  end
end
