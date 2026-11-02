require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::UnicodeMath do
  describe "#described_class" do
    it "returns instance of Unicode" do
      unicode = described_class.new("⎣2.5⎦")
      expect(unicode).to be_a(described_class)
    end

    it "matches UnicodeMath string" do
      unicode = described_class.new("⎣2.5⎦")
      expect(unicode.text).to eql("⎣2.5⎦")
    end
  end

  describe "#to_unicodemath AsciiMath" do
    subject(:string) { formula.to_unicodemath }

    let(:formula) { Plurimath::Math.parse(asciimath_string, :asciimath) }

    it_behaves_like "shared renderer fixture", "renderer-unicode_math-unicode_math-21-1"

    it_behaves_like "shared renderer fixture", "renderer-unicode_math-unicode_math-30-1"

    it_behaves_like "shared renderer fixture", "renderer-unicode_math-unicode_math-39-1"

    it_behaves_like "shared renderer fixture", "renderer-unicode_math-unicode_math-50-1"

    it_behaves_like "shared renderer fixture", "renderer-unicode_math-unicode_math-59-1"

    it_behaves_like "shared renderer fixture", "renderer-unicode_math-unicode_math-68-1"

    it_behaves_like "shared renderer fixture", "renderer-unicode_math-unicode_math-77-1"

    it_behaves_like "shared renderer fixture", "renderer-unicode_math-unicode_math-88-1"

    it_behaves_like "shared renderer fixture", "renderer-unicode_math-unicode_math-97-1"

    it_behaves_like "shared renderer fixture", "renderer-unicode_math-unicode_math-108-1"
  end

  describe "#to_unicodemath LaTeX" do
    subject(:string) { formula.to_unicodemath }

    let(:formula) { Plurimath::Math.parse(latex_string, :latex) }

    it_behaves_like "shared renderer fixture", "renderer-unicode_math-unicode_math-123-1"

    it_behaves_like "shared renderer fixture", "renderer-unicode_math-unicode_math-132-1"

    it_behaves_like "shared renderer fixture", "renderer-unicode_math-unicode_math-141-1"

    it_behaves_like "shared renderer fixture", "renderer-unicode_math-unicode_math-150-1"

    it_behaves_like "shared renderer fixture", "renderer-unicode_math-unicode_math-159-1"
  end

  describe "#to_unicodemath MathML" do
    subject(:string) { formula.to_unicodemath }

    let(:formula) { Plurimath::Math.parse(mathml_string, :mathml) }

    it_behaves_like "shared renderer fixture", "renderer-unicode_math-unicode_math-174-1"
  end
end
