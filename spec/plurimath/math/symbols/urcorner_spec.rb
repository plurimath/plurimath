require "spec_helper"

RSpec.describe Plurimath::Math::Symbols::Urcorner do

  describe ".initialize" do
    it 'returns instance of Symbol Urcorner' do
      klass = described_class.new
      expect(klass).to be_a(Plurimath::Math::Symbols::Urcorner)
    end
  end

  describe "All language conversion specs" do
    subject(:klass) { described_class.new }

    context "Matches all conversion for the Symbol Plurimath::Math::Symbols::Urcorner" do
      it "matches AsciiMath string" do
        expect(klass.to_asciimath).to eq("__{urcorner}")
      end

      it "matches LaTeX string" do
        expect(klass.to_latex).to eq("\\urcorner")
      end

      it "matches UnicodeMath string" do
        expect(klass.to_unicodemath).to eq("⌝")
      end

      it "matches OMML string" do
        expect(klass.to_omml_without_math_tag(true)).to eq("&#x231d;")
      end

      it "matches MathML string" do
        string = dump_ox_nodes(klass.to_mathml_without_math_tag).strip
        expect(string).to eq("<mi>&#x231d;</mi>")
      end

      it "matches HTML string" do
        expect(klass.to_html).to eq("&#x231d;")
      end
    end
  end
end
