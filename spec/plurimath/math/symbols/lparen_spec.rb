require "spec_helper"

RSpec.describe Plurimath::Math::Symbols::Lparen do

  describe ".initialize" do
    it 'returns instance of Symbol Lparen' do
      klass = described_class.new
      expect(klass).to be_a(Plurimath::Math::Symbols::Lparen)
    end
  end

  describe "All language conversion specs" do
    subject(:klass) { described_class.new }

    context "Matches all conversion for the Symbol Plurimath::Math::Symbols::Lparen" do
      it "matches AsciiMath string" do
        expect(klass.to_asciimath).to eq("\"P{lparen}\"")
      end

      it "matches LaTeX string" do
        expect(klass.to_latex).to eq("\\lparen")
      end

      it "matches UnicodeMath string" do
        expect(klass.to_unicodemath).to eq("(")
      end

      it "matches OMML string" do
        expect(klass.to_omml_without_math_tag(true)).to eq("&#x28;")
      end

      it "matches MathML string" do
        string = dump_ox_nodes(klass.to_mathml_without_math_tag(false)).strip
        expect(string).to eq("<mi>&#x28;</mi>")
      end

      it "matches HTML string" do
        expect(klass.to_html).to eq("&#x28;")
      end
    end
  end
end
