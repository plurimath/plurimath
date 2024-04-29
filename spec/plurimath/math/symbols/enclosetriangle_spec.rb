require "spec_helper"

RSpec.describe Plurimath::Math::Symbols::Enclosetriangle do

  describe ".initialize" do
    it 'returns instance of Symbol Enclosetriangle' do
      klass = described_class.new
      expect(klass).to be_a(Plurimath::Math::Symbols::Enclosetriangle)
    end
  end

  describe "All language conversion specs" do
    subject(:klass) { described_class.new }

    context "Matches all conversion for the Symbol Plurimath::Math::Symbols::Enclosetriangle" do
      it "matches AsciiMath string" do
        expect(klass.to_asciimath).to eq("__{enclosetriangle}")
      end

      it "matches LaTeX string" do
        expect(klass.to_latex).to eq("\\enclosetriangle")
      end

      it "matches UnicodeMath string" do
        expect(klass.to_unicodemath).to eq("⃤")
      end

      it "matches OMML string" do
        expect(klass.to_omml_without_math_tag(true)).to eq("&#x20e4;")
      end

      it "matches MathML string" do
        string = dump_ox_nodes(klass.to_mathml_without_math_tag).strip
        expect(string).to eq("<mi>&#x20e4;</mi>")
      end

      it "matches HTML string" do
        expect(klass.to_html).to eq("&#x20e4;")
      end
    end
  end
end