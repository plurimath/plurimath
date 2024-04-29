require "spec_helper"

RSpec.describe Plurimath::Math::Symbols::Nu do

  describe ".initialize" do
    it 'returns instance of Symbol Nu' do
      klass = described_class.new
      expect(klass).to be_a(Plurimath::Math::Symbols::Nu)
    end
  end

  describe "All language conversion specs" do
    subject(:klass) { described_class.new }

    context "Matches all conversion for the Symbol Plurimath::Math::Symbols::Nu" do
      it "matches AsciiMath string" do
        expect(klass.to_asciimath).to eq("nu")
      end

      it "matches LaTeX string" do
        expect(klass.to_latex).to eq("\\nu")
      end

      it "matches UnicodeMath string" do
        expect(klass.to_unicodemath).to eq("ν")
      end

      it "matches OMML string" do
        expect(klass.to_omml_without_math_tag(true)).to eq("&#x3bd;")
      end

      it "matches MathML string" do
        string = dump_ox_nodes(klass.to_mathml_without_math_tag).strip
        expect(string).to eq("<mi>&#x3bd;</mi>")
      end

      it "matches HTML string" do
        expect(klass.to_html).to eq("&#x3bd;")
      end
    end
  end
end
