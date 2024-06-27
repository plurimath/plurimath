require "spec_helper"

RSpec.describe Plurimath::Math::Symbols::Cwgapcirclearrow do

  describe ".initialize" do
    it 'returns instance of Symbol Cwgapcirclearrow' do
      klass = described_class.new
      expect(klass).to be_a(Plurimath::Math::Symbols::Cwgapcirclearrow)
    end
  end

  describe "All language conversion specs" do
    subject(:klass) { described_class.new }

    context "Matches all conversion for the Symbol Plurimath::Math::Symbols::Cwgapcirclearrow" do
      it "matches AsciiMath string" do
        expect(klass.to_asciimath).to eq("__{cwgapcirclearrow}")
      end

      it "matches LaTeX string" do
        expect(klass.to_latex).to eq("\\cwgapcirclearrow")
      end

      it "matches UnicodeMath string" do
        expect(klass.to_unicodemath).to eq("⟳")
      end

      it "matches OMML string" do
        expect(klass.to_omml_without_math_tag(true)).to eq("&#x27f3;")
      end

      it "matches MathML string" do
        string = dump_ox_nodes(klass.to_mathml_without_math_tag(false)).strip
        expect(string).to eq("<mi>&#x27f3;</mi>")
      end

      it "matches HTML string" do
        expect(klass.to_html).to eq("&#x27f3;")
      end
    end
  end
end
