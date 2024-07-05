require "spec_helper"

RSpec.describe Plurimath::Math::Symbols::Squarevfill do

  describe ".initialize" do
    it 'returns instance of Symbol Squarevfill' do
      klass = described_class.new
      expect(klass).to be_a(Plurimath::Math::Symbols::Squarevfill)
    end
  end

  describe "All language conversion specs" do
    subject(:klass) { described_class.new }

    context "Matches all conversion for the Symbol Plurimath::Math::Symbols::Squarevfill" do
      it "matches AsciiMath string" do
        expect(klass.to_asciimath).to eq("__{squarevfill}")
      end

      it "matches LaTeX string" do
        expect(klass.to_latex).to eq("\\squarevfill")
      end

      it "matches UnicodeMath string" do
        expect(klass.to_unicodemath).to eq("▥")
      end

      it "matches OMML string" do
        expect(klass.to_omml_without_math_tag(true)).to eq("&#x25a5;")
      end

      it "matches MathML string" do
        string = dump_ox_nodes(klass.to_mathml_without_math_tag(false)).strip
        expect(string).to eq("<mi>&#x25a5;</mi>")
      end

      it "matches HTML string" do
        expect(klass.to_html).to eq("&#x25a5;")
      end
    end
  end
end
