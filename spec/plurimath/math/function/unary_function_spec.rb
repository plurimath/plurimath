require "spec_helper"

RSpec.describe Plurimath::Math::Function::UnaryFunction do

  describe ".initialize" do
      it 'returns instance of UnaryFunction' do
        unary_function = Plurimath::Math::Function::UnaryFunction.new("sum")
        expect(unary_function).to be_a(Plurimath::Math::Function::UnaryFunction)
      end

      it 'initializes UnaryFunction object' do
      unary_function = Plurimath::Math::Function::UnaryFunction.new("sum")
      expect(unary_function.parameter_one).to eql("sum")
    end
  end

  describe ".to_asciimath" do
    subject(:formula) { Plurimath::Math::Function::UnaryFunction.new(first_value) }

    context "contains sum fuction" do
      let(:first_value) { Plurimath::Math::Function::Sum.new }
      it "returns asciimath string" do
        expect(formula.to_asciimath(options: {})).to eq("unaryfunction(sum)")
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
      let(:first_value) { Plurimath::Math::Symbols::Symbol.new("Theta") }
      expected_value = Plurimath::Math::Function::UnaryFunction.new(
                        Plurimath::Math::Symbols::Symbol.new("theta")
                      )
      it "returns false" do
        expect(formula == expected_value).to be_falsey
      end
    end

    context "contains symbols fuction" do
      let(:first_value) { Plurimath::Math::Symbols::Symbol.new("square") }
      expected_value = Plurimath::Math::Function::UnaryFunction.new(
                        Plurimath::Math::Symbols::Symbol.new("theta")
                      )
      it "returns false" do
        expect(formula == expected_value).to be_falsey
      end
    end
  end
end
