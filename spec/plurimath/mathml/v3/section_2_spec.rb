require_relative "../../../../lib/plurimath/mathml"

RSpec.describe Plurimath::Mathml::Parser do

  subject(:formula) { Plurimath::Mathml::Parser.new(exp).parse }

  context "contains mathml v3 #2 example #1" do
    let(:exp) {
      <<~MATHML
        <math>
          <mtext>&#xA0;<!--NO-BREAK SPACE-->Theorem &#xA0;<!--NO-BREAK SPACE-->1:</mtext>
        </math>
      MATHML
    }
    it "returns formula of sin from mathml string" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Text.new("&#xa0;Theorem &#xa0;1:"),
      ])
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #2 example #2" do
    let(:exp) {
      <<~MATHML
        <math>
          <mtext>
            Theorem
            1:
          </mtext>
        </math>
      MATHML
    }
    it "returns formula of sin from mathml string" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Text.new("&#xa;    Theorem&#xa;    1:&#xa;  "),
      ])
      expect(formula).to eq(expected_value)
    end
  end
end
