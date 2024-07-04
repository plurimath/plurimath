require "spec_helper"

RSpec.describe Plurimath::Math::Symbols::Lat do

  describe ".initialize" do
    it 'returns instance of Symbol Lat' do
      klass = described_class.new
      expect(klass).to be_a(Plurimath::Math::Symbols::Lat)
    end
  end

  describe "All language conversion specs" do
    subject(:klass) { described_class.new }

    context "Matches all conversion for the Symbol Plurimath::Math::Symbols::Lat" do
      it "matches AsciiMath string" do
        expect(klass.to_asciimath).to eq("\"P{lat}\"")
      end

      it "matches LaTeX string" do
        expect(klass.to_latex).to eq("\\lat")
      end

      it "matches UnicodeMath string" do
        expect(klass.to_unicodemath).to eq("⪫")
      end

      it "matches OMML string" do
        expect(klass.to_omml_without_math_tag(true)).to eq("&#x2aab;")
      end

      it "matches MathML string" do
        string = dump_ox_nodes(klass.to_mathml_without_math_tag(false)).strip
        expect(string).to eq("<mi>&#x2aab;</mi>")
      end

      it "matches HTML string" do
        expect(klass.to_html).to eq("&#x2aab;")
      end
    end
  end
end
