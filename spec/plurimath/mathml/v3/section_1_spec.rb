require "spec_helper"
require_relative "../../../support/shared_model_fixtures"

RSpec.describe Plurimath::Mathml::Parser do
  subject(:formula) { described_class.new(exp).parse }

  context "contains mathml v3 #1 example" do
    let(:exp) do
      <<~MATHML
        <math>
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
        </math>
      MATHML
    end

    it "returns formula of sin from mathml string" do
      expected_value = SharedModelFixtures.model(
        "mathml/scripts", "mathml-scripts-012", input: exp
      )
      expect(formula).to eq(expected_value)
    end
  end
end
