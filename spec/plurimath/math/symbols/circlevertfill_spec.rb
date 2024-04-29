require "spec_helper"

RSpec.describe Plurimath::Math::Symbols::Circlevertfill do

  describe ".initialize" do
    it 'returns instance of Symbol Circlevertfill' do
      klass = described_class.new
      expect(klass).to be_a(Plurimath::Math::Symbols::Circlevertfill)
    end
  end

  describe "All language conversion specs" do
    subject(:klass) { described_class.new }

    context "Matches all conversion for the Symbol Plurimath::Math::Symbols::Circlevertfill" do
      it "matches AsciiMath string" do
        expect(klass.to_asciimath).to eq("__{circlevertfill}")
      end

      it "matches LaTeX string" do
        expect(klass.to_latex).to eq("\\circlevertfill")
      end

      it "matches UnicodeMath string" do
        expect(klass.to_unicodemath).to eq("◍")
      end

      it "matches OMML string" do
        expect(klass.to_omml_without_math_tag(true)).to eq("&#x25cd;")
      end

      it "matches MathML string" do
        string = dump_ox_nodes(klass.to_mathml_without_math_tag).strip
        expect(string).to eq("<mi>&#x25cd;</mi>")
      end

      it "matches HTML string" do
        expect(klass.to_html).to eq("&#x25cd;")
      end
    end
  end
end
