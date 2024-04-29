require "spec_helper"

RSpec.describe Plurimath::Math::Symbols::Pentagon do

  describe ".initialize" do
    it 'returns instance of Symbol Pentagon' do
      klass = described_class.new
      expect(klass).to be_a(Plurimath::Math::Symbols::Pentagon)
    end
  end

  describe "All language conversion specs" do
    subject(:klass) { described_class.new }

    context "Matches all conversion for the Symbol Plurimath::Math::Symbols::Pentagon" do
      it "matches AsciiMath string" do
        expect(klass.to_asciimath).to eq("__{pentagon}")
      end

      it "matches LaTeX string" do
        expect(klass.to_latex).to eq("\\pentagon")
      end

      it "matches UnicodeMath string" do
        expect(klass.to_unicodemath).to eq("⬠")
      end

      it "matches OMML string" do
        expect(klass.to_omml_without_math_tag(true)).to eq("&#x2b20;")
      end

      it "matches MathML string" do
        string = dump_ox_nodes(klass.to_mathml_without_math_tag).strip
        expect(string).to eq("<mi>&#x2b20;</mi>")
      end

      it "matches HTML string" do
        expect(klass.to_html).to eq("&#x2b20;")
      end
    end
  end
end
