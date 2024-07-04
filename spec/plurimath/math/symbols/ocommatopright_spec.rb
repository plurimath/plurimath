require "spec_helper"

RSpec.describe Plurimath::Math::Symbols::Ocommatopright do

  describe ".initialize" do
    it 'returns instance of Symbol Ocommatopright' do
      klass = described_class.new
      expect(klass).to be_a(Plurimath::Math::Symbols::Ocommatopright)
    end
  end

  describe "All language conversion specs" do
    subject(:klass) { described_class.new }

    context "Matches all conversion for the Symbol Plurimath::Math::Symbols::Ocommatopright" do
      it "matches AsciiMath string" do
        expect(klass.to_asciimath).to eq("\"P{ocommatopright}\"")
      end

      it "matches LaTeX string" do
        expect(klass.to_latex).to eq("\\ocommatopright")
      end

      it "matches UnicodeMath string" do
        expect(klass.to_unicodemath).to eq("̕")
      end

      it "matches OMML string" do
        expect(klass.to_omml_without_math_tag(true)).to eq("&#x315;")
      end

      it "matches MathML string" do
        string = dump_ox_nodes(klass.to_mathml_without_math_tag(false)).strip
        expect(string).to eq("<mi>&#x315;</mi>")
      end

      it "matches HTML string" do
        expect(klass.to_html).to eq("&#x315;")
      end
    end
  end
end
