require "spec_helper"

RSpec.describe Plurimath::Math::Symbols::Asymp do

  describe ".initialize" do
    it 'returns instance of Symbol Asymp' do
      klass = described_class.new
      expect(klass).to be_a(Plurimath::Math::Symbols::Asymp)
    end
  end

  describe "All language conversion specs" do
    subject(:klass) { described_class.new }

    context "Matches all conversion for the Symbol Plurimath::Math::Symbols::Asymp" do
      it "matches AsciiMath string" do
        expect(klass.to_asciimath).to eq("\"P{asymp}\"")
      end

      it "matches LaTeX string" do
        expect(klass.to_latex).to eq("\\asymp")
      end

      it "matches UnicodeMath string" do
        expect(klass.to_unicodemath).to eq("≍")
      end

      it "matches OMML string" do
        expect(klass.to_omml_without_math_tag(true)).to eq("&#x224d;")
      end

      it "matches MathML string" do
        string = dump_ox_nodes(klass.to_mathml_without_math_tag(false)).strip
        expect(string).to eq("<mi>&#x224d;</mi>")
      end

      it "matches HTML string" do
        expect(klass.to_html).to eq("&#x224d;")
      end
    end
  end
end
