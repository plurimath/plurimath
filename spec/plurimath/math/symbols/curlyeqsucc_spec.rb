require "spec_helper"

RSpec.describe Plurimath::Math::Symbols::Curlyeqsucc do

  describe ".initialize" do
    it 'returns instance of Symbol Curlyeqsucc' do
      klass = described_class.new
      expect(klass).to be_a(Plurimath::Math::Symbols::Curlyeqsucc)
    end
  end

  describe "All language conversion specs" do
    subject(:klass) { described_class.new }

    context "Matches all conversion for the Symbol Plurimath::Math::Symbols::Curlyeqsucc" do
      it "matches AsciiMath string" do
        expect(klass.to_asciimath).to eq("\"P{curlyeqsucc}\"")
      end

      it "matches LaTeX string" do
        expect(klass.to_latex).to eq("\\curlyeqsucc")
      end

      it "matches UnicodeMath string" do
        expect(klass.to_unicodemath).to eq("⋟")
      end

      it "matches OMML string" do
        expect(klass.to_omml_without_math_tag(true)).to eq("&#x22df;")
      end

      it "matches MathML string" do
        string = dump_ox_nodes(klass.to_mathml_without_math_tag(false)).strip
        expect(string).to eq("<mi>&#x22df;</mi>")
      end

      it "matches HTML string" do
        expect(klass.to_html).to eq("&#x22df;")
      end
    end
  end
end
