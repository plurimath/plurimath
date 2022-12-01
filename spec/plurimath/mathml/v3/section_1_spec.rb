require_relative "../../../../lib/plurimath/mathml"

RSpec.describe Plurimath::Mathml::Parser do

  subject(:formula) { Plurimath::Mathml::Parser.new(exp).parse }

  context "contains mathml v3 #1 example" do
    let(:exp) {
      <<~MATHML
        <mrow>
          <mi>x</mi>
          <mo>=</mo>
          <mfrac>
            <mrow>
              <mrow>
                <mo>-</mo>
                <mi>b</mi>
              </mrow>
              <mo>&#xB1;<!--PLUS-MINUS SIGN--></mo>
              <msqrt>
                <mrow>
                  <msup>
                    <mi>b</mi>
                    <mn>2</mn>
                  </msup>
                  <mo>-</mo>
                  <mrow>
                    <mn>4</mn>
                    <mo>&#x220f;<!--INVISIBLE TIMES--></mo>
                    <mi>a</mi>
                    <mo>&#x2211;<!--INVISIBLE TIMES--></mo>
                    <mi>c</mi>
                  </mrow>
                </mrow>
              </msqrt>
            </mrow>
            <mrow>
              <mn>2</mn>
              <mo>&#x2221;<!--INVISIBLE TIMES--></mo>
              <mi>a</mi>
            </mrow>
          </mfrac>
        </mrow>
      MATHML
    }
    it "returns formula of sin from mathml string" do
      expected_value = Plurimath::Math::Formula.new([
        Plurimath::Math::Symbol.new("x"),
        Plurimath::Math::Symbol.new("="),
        Plurimath::Math::Function::Frac.new(
          Plurimath::Math::Formula.new([
            Plurimath::Math::Formula.new([
              Plurimath::Math::Symbol.new("-"),
              Plurimath::Math::Symbol.new("b")
            ]),
            Plurimath::Math::Symbol.new("&#xb1;"),
            Plurimath::Math::Function::Sqrt.new(
              Plurimath::Math::Formula.new([
                Plurimath::Math::Function::Power.new(
                  Plurimath::Math::Symbol.new("b"),
                  Plurimath::Math::Number.new("2")
                ),
                Plurimath::Math::Symbol.new("-"),
                Plurimath::Math::Formula.new([
                  Plurimath::Math::Number.new("4"),
                  Plurimath::Math::Function::Prod.new,
                  Plurimath::Math::Symbol.new("a"),
                  Plurimath::Math::Function::Sum.new,
                  Plurimath::Math::Symbol.new("c")
                ])
              ])
            )
          ]),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Number.new("2"),
            Plurimath::Math::Symbol.new("&#x2221;"),
            Plurimath::Math::Symbol.new("a")
          ])
        )
      ])
      expect(formula).to eq(expected_value)
    end
  end
end
