require "spec_helper"

RSpec.describe Plurimath::Math::Function::Unitsml do
  describe "Plurimath::Math.parse with :unitsml" do
    subject(:formula) { Plurimath::Math.parse("m", :unitsml) }

    it "returns a Unitsml function carrying the input string" do
      expect(formula).to be_a(described_class)
      expect(formula.text).to eq("m")
      expect(formula.input_string).to eq("m")
    end
  end
end
