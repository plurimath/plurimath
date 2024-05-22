require "spec_helper"

RSpec.describe Plurimath::Math::Symbols::Dd do

  describe ".initialize" do
    it 'returns instance of Symbol Dd' do
      klass = described_class.new
      expect(klass).to be_a(Plurimath::Math::Symbols::Dd)
    end
  end

  describe "All language conversion specs" do
    subject(:klass) { described_class.new }

    context "Matches all conversion for the Symbol Plurimath::Math::Symbols::Dd" do
      it "matches AsciiMath string" do
        expect(klass.to_asciimath).to eq("__{dd}")
      end

      it "matches LaTeX string" do
        expect(klass.to_latex).to eq("\\DifferentialD")
      end

      it "matches UnicodeMath string" do
        expect(klass.to_unicodemath).to eq("ⅆ")
      end

      it "matches OMML string" do
        expect(klass.to_omml_without_math_tag(true)).to eq("&#x2146;")
      end

      it "matches MathML string" do
        string = dump_ox_nodes(klass.to_mathml_without_math_tag(false)).strip
        expect(string).to eq("<mi>&#x2146;</mi>")
      end

      it "matches HTML string" do
        expect(klass.to_html).to eq("&#x2146;")
      end
    end
  end
end
