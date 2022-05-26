require_relative '../../../../lib/plurimath/asciimath'

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
      let(:second_value) { Plurimath::Math::Symbol.new("theta") }
      it "returns asciimath string" do
        expect(formula.to_asciimath).to eq("binaryfunction(sum)(theta)")
      end
    end
  end

  describe ".value_to_asciimath" do
    subject(:formula) { Plurimath::Math::Function::BinaryFunction.new(first_value, second_value) }

    context "contains a symbol and sum fuction" do
      let(:first_value) { Plurimath::Math::Function::Sum.new }
      let(:second_value) { Plurimath::Math::Symbol.new("theta") }
      it "returns asciimath string" do
        expect(formula.value_to_asciimath).to eq("(sum)(theta)")
      end
    end

    context "contains a fuction only" do
      let(:first_value) { Plurimath::Math::Function::Sum.new }
      let(:second_value) { nil }
      it "returns asciimath string" do
        expect(formula.value_to_asciimath).to eq("(sum)")
      end
    end

    context "contains a symbol" do
      let(:first_value) { nil }
      let(:second_value) { Plurimath::Math::Symbol.new("theta") }
      it "returns asciimath string" do
        expect(formula.value_to_asciimath).to eq("(theta)")
      end
    end

    context "contains nil values" do
      let(:first_value) { nil }
      let(:second_value) { nil }
      it "returns empty string" do
        expect(formula.value_to_asciimath).to eq("")
      end
    end
  end

  describe ".==" do
    subject(:formula) { Plurimath::Math::Function::BinaryFunction.new(first_value, second_value) }

    context "contains a symbol and sum fuction" do
      let(:first_value) { Plurimath::Math::Function::Sum.new }
      let(:second_value) { Plurimath::Math::Symbol.new("theta") }
      expected_value = Plurimath::Math::Function::BinaryFunction.new(
                        Plurimath::Math::Function::Sum.new,
                        Plurimath::Math::Symbol.new("theta")
                      )
      it "returns true" do
        expect(formula == expected_value ).to be_truthy
      end
    end

    context "contains a symbol only" do
      let(:first_value) { nil }
      let(:second_value) { Plurimath::Math::Symbol.new("theta") }
      expected_value = Plurimath::Math::Function::BinaryFunction.new(
                        nil,
                        Plurimath::Math::Symbol.new("theta")
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
      let(:second_value) { Plurimath::Math::Symbol.new("theta") }
      expected_value = Plurimath::Math::Function::BinaryFunction.new(
                        nil,
                        Plurimath::Math::Symbol.new("theta")
                      )
      it "returns false" do
        expect(formula == expected_value ).to be_falsey
      end
    end

    context "contains a prod and symbol fuction" do
      let(:first_value) { Plurimath::Math::Function::Sum.new }
      let(:second_value) { Plurimath::Math::Symbol.new("theta") }
      expected_value = Plurimath::Math::Function::BinaryFunction.new(
                        Plurimath::Math::Function::Prod.new,
                        Plurimath::Math::Symbol.new("theta")
                      )
      it "returns false" do
        expect(formula == expected_value ).to be_falsey
      end
    end
  end
end
