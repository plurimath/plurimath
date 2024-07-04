require "spec_helper"

RSpec.describe Plurimath::Math::Symbols::Updownharpoonrightleft do

  describe ".initialize" do
    it 'returns instance of Symbol Updownharpoonrightleft' do
      klass = described_class.new
      expect(klass).to be_a(Plurimath::Math::Symbols::Updownharpoonrightleft)
    end
  end

  describe "All language conversion specs" do
    subject(:klass) { described_class.new }

    context "Matches all conversion for the Symbol Plurimath::Math::Symbols::Updownharpoonrightleft" do
      it "matches AsciiMath string" do
        expect(klass.to_asciimath).to eq("\"P{updownharpoonrightleft}\"")
      end

      it "matches LaTeX string" do
        expect(klass.to_latex).to eq("\\updownharpoonrightleft")
      end

      it "matches UnicodeMath string" do
        expect(klass.to_unicodemath).to eq("⥌")
      end

      it "matches OMML string" do
        expect(klass.to_omml_without_math_tag(true)).to eq("&#x294c;")
      end

      it "matches MathML string" do
        string = dump_ox_nodes(klass.to_mathml_without_math_tag(false)).strip
        expect(string).to eq("<mi>&#x294c;</mi>")
      end

      it "matches HTML string" do
        expect(klass.to_html).to eq("&#x294c;")
      end
    end
  end
end
