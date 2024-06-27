require "spec_helper"

RSpec.describe Plurimath::Math::Symbols::Succeq do

  describe ".initialize" do
    it 'returns instance of Symbol Succeq' do
      klass = described_class.new
      expect(klass).to be_a(Plurimath::Math::Symbols::Succeq)
    end
  end

  describe "All language conversion specs" do
    subject(:klass) { described_class.new }

    context "Matches all conversion for the Symbol Plurimath::Math::Symbols::Succeq" do
      it "matches AsciiMath string" do
        expect(klass.to_asciimath).to eq("succeq")
      end

      it "matches LaTeX string" do
        expect(klass.to_latex).to eq("\\succeq")
      end

      it "matches UnicodeMath string" do
        expect(klass.to_unicodemath).to eq("⪰")
      end

      it "matches OMML string" do
        expect(klass.to_omml_without_math_tag(true)).to eq("&#x2ab0;")
      end

      it "matches MathML string" do
        string = dump_ox_nodes(klass.to_mathml_without_math_tag(false)).strip
        expect(string).to eq("<mi>&#x2ab0;</mi>")
      end

      it "matches HTML string" do
        expect(klass.to_html).to eq("&#x2ab0;")
      end
    end
  end
end
