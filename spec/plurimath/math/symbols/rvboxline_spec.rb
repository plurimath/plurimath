require "spec_helper"

RSpec.describe Plurimath::Math::Symbols::Rvboxline do

  describe ".initialize" do
    it 'returns instance of Symbol Rvboxline' do
      klass = described_class.new
      expect(klass).to be_a(Plurimath::Math::Symbols::Rvboxline)
    end
  end

  describe "All language conversion specs" do
    subject(:klass) { described_class.new }

    context "Matches all conversion for the Symbol Plurimath::Math::Symbols::Rvboxline" do
      it "matches AsciiMath string" do
        expect(klass.to_asciimath).to eq("\"P{rvboxline}\"")
      end

      it "matches LaTeX string" do
        expect(klass.to_latex).to eq("\\rvboxline")
      end

      it "matches UnicodeMath string" do
        expect(klass.to_unicodemath).to eq("⎹")
      end

      it "matches OMML string" do
        expect(klass.to_omml_without_math_tag(true)).to eq("&#x23b9;")
      end

      it "matches MathML string" do
        string = dump_ox_nodes(klass.to_mathml_without_math_tag(false)).strip
        expect(string).to eq("<mi>&#x23b9;</mi>")
      end

      it "matches HTML string" do
        expect(klass.to_html).to eq("&#x23b9;")
      end
    end
  end
end
