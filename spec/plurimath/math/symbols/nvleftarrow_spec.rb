require "spec_helper"

RSpec.describe Plurimath::Math::Symbols::Nvleftarrow do

  describe ".initialize" do
    it 'returns instance of Symbol Nvleftarrow' do
      klass = described_class.new
      expect(klass).to be_a(Plurimath::Math::Symbols::Nvleftarrow)
    end
  end

  describe "All language conversion specs" do
    subject(:klass) { described_class.new }

    context "Matches all conversion for the Symbol Plurimath::Math::Symbols::Nvleftarrow" do
      it "matches AsciiMath string" do
        expect(klass.to_asciimath).to eq("\"P{nvLeftarrow}\"")
      end

      it "matches LaTeX string" do
        expect(klass.to_latex).to eq("\\nvLeftarrow")
      end

      it "matches UnicodeMath string" do
        expect(klass.to_unicodemath).to eq("⤂")
      end

      it "matches OMML string" do
        expect(klass.to_omml_without_math_tag(true)).to eq("&#x2902;")
      end

      it "matches MathML string" do
        string = dump_ox_nodes(klass.to_mathml_without_math_tag(false)).strip
        expect(string).to eq("<mi>&#x2902;</mi>")
      end

      it "matches HTML string" do
        expect(klass.to_html).to eq("&#x2902;")
      end
    end
  end
end
