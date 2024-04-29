require "spec_helper"

RSpec.describe Plurimath::Mathml::Parser do

  subject(:formula) { Plurimath::Mathml::Parser.new(exp).parse }

  context "contains mathml v3 #7 example #210" do
    let(:exp) {
      <<~MATHML
        <math>
          <mo>''</mo>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Symbols::Symbol.new("&#x27;&#x27;"),
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #7 example #211" do
    let(:exp) {
      <<~MATHML
        <math>
          <msup>
            <mi>x</mi>
            <mo>&#x2032;<!--PRIME--><!--PRIME--></mo>
          </msup>
        </math>
      MATHML
    }
    it "returns formula of decimal values" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Power.new(
          Plurimath::Math::Symbols::Symbol.new("x"),
          Plurimath::Math::Symbols::Prime.new,
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end
end
