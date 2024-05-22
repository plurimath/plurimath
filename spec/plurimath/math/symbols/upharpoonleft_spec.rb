require "spec_helper"

RSpec.describe Plurimath::Math::Symbols::Upharpoonleft do

  describe ".initialize" do
    it 'returns instance of Symbol Upharpoonleft' do
      klass = described_class.new
      expect(klass).to be_a(Plurimath::Math::Symbols::Upharpoonleft)
    end
  end

  describe "All language conversion specs" do
    subject(:klass) { described_class.new }

    context "Matches all conversion for the Symbol Plurimath::Math::Symbols::Upharpoonleft" do
      it "matches AsciiMath string" do
        expect(klass.to_asciimath).to eq("__{upharpoonleft}")
      end

      it "matches LaTeX string" do
        expect(klass.to_latex).to eq("\\upharpoonleftup")
      end

      it "matches UnicodeMath string" do
        expect(klass.to_unicodemath).to eq("↿")
      end

      it "matches OMML string" do
        expect(klass.to_omml_without_math_tag(true)).to eq("&#x21bf;")
      end

      it "matches MathML string" do
        string = dump_ox_nodes(klass.to_mathml_without_math_tag(false)).strip
        expect(string).to eq("<mi>&#x21bf;</mi>")
      end

      it "matches HTML string" do
        expect(klass.to_html).to eq("&#x21bf;")
      end
    end
  end
end
