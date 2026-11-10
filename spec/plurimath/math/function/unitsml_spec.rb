require "spec_helper"

RSpec.describe Plurimath::Math::Function::Unitsml do
  describe "Plurimath::Math.parse with :unitsml" do
    subject(:formula) { Plurimath::Math.parse("m", :unitsml) }

    it "returns a Formula holding the Unitsml function and the input string" do
      expect(formula).to be_a(Plurimath::Math::Formula)
      expect(formula.value.map(&:class)).to eq([described_class])
      expect(formula.value.first.text).to eq("m")
      expect(formula.input_string).to eq("m")
    end

    it "writes directly to the other formats" do
      formula = Plurimath::Math.parse("m*s^-2", :unitsml)
      expect(formula.to_asciimath).to eq("rm(m) * rm(s)^(- 2)")
      expect { formula.to_latex }.not_to raise_error
      expect { formula.to_mathml }.not_to raise_error
      expect { formula.to_omml }.not_to raise_error
      expect { formula.to_html }.not_to raise_error
    end
  end
end
