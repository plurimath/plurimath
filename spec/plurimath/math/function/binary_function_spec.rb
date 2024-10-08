require "spec_helper"

RSpec.describe Plurimath::Math::Function::BinaryFunction do

  it 'returns instance of BinaryFunction' do
    binary_function = Plurimath::Math::Function::BinaryFunction.new("sum", "theta")
    expect(binary_function).to be_a(Plurimath::Math::Function::BinaryFunction)
  end

  it 'initializes BinaryFunction object' do
    binary_function = Plurimath::Math::Function::BinaryFunction.new("sum", "theta")
    expect(binary_function.parameter_one).to eql("sum")
    expect(binary_function.parameter_two).to eql("theta")
  end

  describe ".to_asciimath" do
    subject(:formula) { Plurimath::Math::Function::BinaryFunction.new(first_value, second_value) }

    context "contains a symbol and sum fuction" do
      let(:first_value) { Plurimath::Math::Function::Sum.new }
      let(:second_value) { Plurimath::Math::Symbols::Symbol.new("theta") }
      it "returns asciimath string" do
        expect(formula.to_asciimath(options: {})).to eq("binaryfunction(sum)(theta)")
      end
    end
  end

  describe ".==" do
    subject(:formula) { Plurimath::Math::Function::BinaryFunction.new(first_value, second_value) }

    context "contains a symbol and sum fuction" do
      let(:first_value) { Plurimath::Math::Function::Sum.new }
      let(:second_value) { Plurimath::Math::Symbols::Symbol.new("theta") }
      expected_value = Plurimath::Math::Function::BinaryFunction.new(
                        Plurimath::Math::Function::Sum.new,
                        Plurimath::Math::Symbols::Symbol.new("theta")
                      )
      it "returns true" do
        expect(formula == expected_value ).to be_truthy
      end
    end

    context "contains a symbol only" do
      let(:first_value) { nil }
      let(:second_value) { Plurimath::Math::Symbols::Symbol.new("theta") }
      expected_value = Plurimath::Math::Function::BinaryFunction.new(
                        nil,
                        Plurimath::Math::Symbols::Symbol.new("theta")
                      )
      it "returns true" do
        expect(formula == expected_value ).to be_truthy
      end
    end

    context "contains a sum fuction only" do
      let(:first_value) { Plurimath::Math::Function::Sum.new }
      let(:second_value) { nil }
      expected_value = Plurimath::Math::Function::BinaryFunction.new(
                        Plurimath::Math::Function::Sum.new,
                        nil
                      )
      it "returns true" do
        expect(formula == expected_value ).to be_truthy
      end
    end

    context "contains a symbol and sum fuction" do
      let(:first_value) { Plurimath::Math::Function::Sum.new }
      let(:second_value) { Plurimath::Math::Symbols::Symbol.new("theta") }
      expected_value = Plurimath::Math::Function::BinaryFunction.new(
                        nil,
                        Plurimath::Math::Symbols::Symbol.new("theta")
                      )
      it "returns false" do
        expect(formula == expected_value ).to be_falsey
      end
    end

    context "contains a prod and symbol fuction" do
      let(:first_value) { Plurimath::Math::Function::Sum.new }
      let(:second_value) { Plurimath::Math::Symbols::Symbol.new("theta") }
      expected_value = Plurimath::Math::Function::BinaryFunction.new(
                        Plurimath::Math::Function::Prod.new,
                        Plurimath::Math::Symbols::Symbol.new("theta")
                      )
      it "returns false" do
        expect(formula == expected_value ).to be_falsey
      end
    end
  end
end
