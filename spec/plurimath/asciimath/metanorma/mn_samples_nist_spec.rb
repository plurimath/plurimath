require "spec_helper"

# These examples originate from https://github.com/metanorma/mn-samples-nist

RSpec.describe Plurimath::Asciimath::Parser do

  describe ".parse" do
    subject(:formula) { described_class.new(string).parse }

    context "example #01 from /site/documents/NIST.SP.800-90B.presentation.xml" do
      let(:string) { "α" }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("α"),
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "example #01 from /site/documents/NIST.SP.800-90B.xml" do
      let(:string) { "L − p" }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("L"),
          Plurimath::Math::Symbol.new("−"),
          Plurimath::Math::Symbol.new("p"),
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "example #02 from /site/documents/NIST.SP.800-90B.xml" do
      let(:string) { "x_50)" }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Symbol.new("x"),
            Plurimath::Math::Number.new("50")
          ),
          Plurimath::Math::Symbol.new(")")
        ])
        expect(formula).to eq(expected_value)
      end
    end

    context "example #03 from /site/documents/NIST.SP.800-90B.xml" do
      let(:string) { "(text(Key), V ⊕ s_i)" }
      it "returns formula" do
        expected_value = Plurimath::Math::Formula.new([
          Plurimath::Math::Function::Fenced.new(
            Plurimath::Math::Symbol.new("("),
            [
              Plurimath::Math::Function::Text.new("Key"),
              Plurimath::Math::Symbol.new(", "),
              Plurimath::Math::Symbol.new("V"),
              Plurimath::Math::Symbol.new("⊕"),
              Plurimath::Math::Function::Base.new(
                Plurimath::Math::Symbol.new("s"),
                Plurimath::Math::Symbol.new("i")
              )
            ],
            Plurimath::Math::Symbol.new(")")
          )
        ])
        expect(formula).to eq(expected_value)
      end
    end
  end
end
