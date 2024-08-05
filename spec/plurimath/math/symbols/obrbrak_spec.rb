require "spec_helper"

RSpec.describe Plurimath::Math::Symbols::Obrbrak do

  describe ".initialize" do
    it 'returns instance of Symbol Obrbrak' do
      klass = described_class.new
      expect(klass).to be_a(Plurimath::Math::Symbols::Obrbrak)
    end
  end

  describe "All language conversion specs" do
    subject(:klass) { described_class.new }

    context "Matches all conversion for the Symbol Plurimath::Math::Symbols::Obrbrak" do
      it "matches AsciiMath string" do
        expect(klass.to_asciimath).to eq("\"P{obrbrak}\"")
      end

      it "matches LaTeX string" do
        expect(klass.to_latex).to eq("\\obrbrak")
      end

      it "matches UnicodeMath string" do
        expect(klass.to_unicodemath).to eq("⏠")
      end

      it "matches OMML string" do
        expect(klass.to_omml_without_math_tag(true)).to eq("&#x23e0;")
      end

      it "matches MathML string" do
        string = dump_ox_nodes(klass.to_mathml_without_math_tag(false)).strip
        expect(string).to eq("<mi>&#x23e0;</mi>")
      end

      it "matches HTML string" do
        expect(klass.to_html).to eq("&#x23e0;")
      end
    end
  end
end
