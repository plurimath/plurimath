require "spec_helper"
require_relative "../../../support/shared_model_fixtures"

RSpec.describe Plurimath::Mathml::Parser do
  subject(:formula) { described_class.new(exp).parse }

  context "contains mathml v3 #7 example #210" do
    let(:exp) do
      <<~MATHML
        <math>
          <mo>''</mo>
        </math>
      MATHML
    end

    it "returns formula of decimal values" do
      expected_value = SharedModelFixtures.model(
        "mathml/tokens", "mathml-tokens-088", input: exp
      )
      expect(formula).to eq(expected_value)
    end
  end

  context "contains mathml v3 #7 example #211" do
    let(:exp) do
      <<~MATHML
        <math>
          <msup>
            <mi>x</mi>
            <mo>&#x2032;<!--PRIME--><!--PRIME--></mo>
          </msup>
        </math>
      MATHML
    end

    it "returns formula of decimal values" do
      expected_value = SharedModelFixtures.model(
        "mathml/scripts", "mathml-scripts-050", input: exp
      )
      expect(formula).to eq(expected_value)
    end
  end
end
