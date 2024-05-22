require "spec_helper"

RSpec.describe Plurimath::Math::Symbols::Im do

  describe ".initialize" do
    it 'returns instance of Symbol Im' do
      klass = described_class.new
      expect(klass).to be_a(Plurimath::Math::Symbols::Im)
    end
  end

  describe "All language conversion specs" do
    subject(:klass) { described_class.new }

    context "Matches all conversion for the Symbol Plurimath::Math::Symbols::Im" do
      it "matches AsciiMath string" do
        expect(klass.to_asciimath).to eq("__{Im}")
      end

      it "matches LaTeX string" do
        expect(klass.to_latex).to eq("\\Im")
      end

      it "matches UnicodeMath string" do
        expect(klass.to_unicodemath).to eq("ℑ")
      end

      it "matches OMML string" do
        expect(klass.to_omml_without_math_tag(true)).to eq("&#x2111;")
      end

      it "matches MathML string" do
        string = dump_ox_nodes(klass.to_mathml_without_math_tag(false)).strip
        expect(string).to eq("<mi>&#x2111;</mi>")
      end

      it "matches HTML string" do
        expect(klass.to_html).to eq("&#x2111;")
      end
    end
  end
end
