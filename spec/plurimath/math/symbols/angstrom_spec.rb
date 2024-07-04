require "spec_helper"

RSpec.describe Plurimath::Math::Symbols::Angstrom do

  describe ".initialize" do
    it 'returns instance of Symbol Angstrom' do
      klass = described_class.new
      expect(klass).to be_a(Plurimath::Math::Symbols::Angstrom)
    end
  end

  describe "All language conversion specs" do
    subject(:klass) { described_class.new }

    context "Matches all conversion for the Symbol Plurimath::Math::Symbols::Angstrom" do
      it "matches AsciiMath string" do
        expect(klass.to_asciimath).to eq("\"P{Angstrom}\"")
      end

      it "matches LaTeX string" do
        expect(klass.to_latex).to eq("\\Angstroem")
      end

      it "matches UnicodeMath string" do
        expect(klass.to_unicodemath).to eq("Å")
      end

      it "matches OMML string" do
        expect(klass.to_omml_without_math_tag(true)).to eq("&#x212b;")
      end

      it "matches MathML string" do
        string = dump_ox_nodes(klass.to_mathml_without_math_tag(false)).strip
        expect(string).to eq("<mi>&#x212b;</mi>")
      end

      it "matches HTML string" do
        expect(klass.to_html).to eq("&#x212b;")
      end
    end
  end
end
