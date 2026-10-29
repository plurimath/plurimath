require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Math::Function::UnaryFunction do
  describe ".initialize" do
    it "returns instance of UnaryFunction" do
      unary_function = described_class.new("sum")
      expect(unary_function).to be_a(described_class)
    end

    it "initializes UnaryFunction object" do
      unary_function = described_class.new("sum")
      expect(unary_function.parameter_one).to eql("sum")
    end
  end

  describe ".to_asciimath" do
    subject(:formula) { described_class.new(first_value) }

    it_behaves_like "shared renderer fixture", "function-unary_function-19-1"
  end

  describe ".==" do
    subject(:formula) { described_class.new(first_value) }

    context "contains sum fuction" do
      let(:first_value) { Plurimath::Math::Function::Sum.new }

      expected_value = described_class.new(
        Plurimath::Math::Function::Sum.new,
      )
      it "returns true" do
        expect(formula == expected_value).to be_truthy
      end
    end

    context "contains nil unaryfunction" do
      let(:first_value) { nil }

      expected_value = described_class.new(nil)
      it "returns true" do
        expect(formula == expected_value).to be_truthy
      end
    end

    context "contains sum fuction" do
      let(:first_value) { Plurimath::Math::Function::Sum.new }

      expected_value = described_class.new(
        Plurimath::Math::Function::Sum.new,
      )
      it "returns true" do
        expect(formula == expected_value).to be_truthy
      end
    end

    context "contains symbols fuction" do
      let(:first_value) { Plurimath::Math::Symbols::Symbol.new("Theta") }

      expected_value = described_class.new(
        Plurimath::Math::Symbols::Symbol.new("theta"),
      )
      it "returns false" do
        expect(formula == expected_value).to be_falsey
      end
    end

    context "contains symbols fuction" do
      let(:first_value) { Plurimath::Math::Symbols::Symbol.new("square") }

      expected_value = described_class.new(
        Plurimath::Math::Symbols::Symbol.new("theta"),
      )
      it "returns false" do
        expect(formula == expected_value).to be_falsey
      end
    end
  end
end
