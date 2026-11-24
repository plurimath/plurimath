require "spec_helper"

RSpec.describe Plurimath::Math::Formula do
  describe "ISO 80000-2 profile MathML (plurimath#142)" do
    def mathml(text, **opts)
      Plurimath::Math.parse(text, :asciimath).to_mathml(**opts).gsub(/\s+/, "")
    end

    let(:upright) { 'mathvariant="normal"' }

    it "renders big Pi, F, G, H upright when written as a call" do
      out = mathml("Pi(n, phi, k) + F(x) + G(y) + H(z)", profile: :iso80000part2)
      expect(out).to include("<mi#{upright}>&#x3a0;</mi><mrow>")
      %w[F G H].each { |n| expect(out).to include("<mi#{upright}>#{n}</mi><mrow>") }
    end

    it "leaves the call arguments as ordinary variables" do
      out = mathml("Pi(n, phi, k)", profile: :iso80000part2)
      expect(out).to include("<mi>n</mi>", "<mi>&#x3d5;</mi>", "<mi>k</mi>")
    end

    it "keeps a bare Pi or F without a call unstyled" do
      out = mathml("Pi + F + a", profile: :iso80000part2)
      expect(out).not_to include("mathvariant")
    end

    it "renders pi upright in the profile" do
      expect(mathml("pi", profile: :iso80000part2)).to include("<mi#{upright}>&#x3c0;</mi>")
    end

    it "does not change output when the profile is off" do
      text = "Pi(n, phi, k) + F(x) + pi"
      expect(mathml(text)).to eq(mathml(text, profile: nil))
      expect(mathml(text)).not_to include("mathvariant")
    end
  end
end
