require "spec_helper"

RSpec.describe Plurimath::Math::Symbols::Cc do

  describe ".initialize" do
    it 'returns instance of Symbol Cc' do
      klass = described_class.new
      expect(klass).to be_a(Plurimath::Math::Symbols::Cc)
    end
  end

  describe "All language conversion specs" do
    subject(:klass) { described_class.new }

    context "Matches all conversion for the Symbol Plurimath::Math::Symbols::Cc" do
      it "matches AsciiMath string" do
        expect(klass.to_asciimath).to eq("mathbb(C)")
      end

      it "matches LaTeX string" do
        expect(klass.to_latex).to eq("\\mathbb{C}")
      end

      it "matches UnicodeMath string" do
        expect(klass.to_unicodemath).to eq("ℂ")
      end

      it "matches OMML string" do
        expect(klass.to_omml_without_math_tag(true)).to eq("&#x2102;")
      end

      it "matches MathML string" do
        string = dump_ox_nodes(klass.to_mathml_without_math_tag(false)).gsub(/>\s+</, "><").strip
        expect(string).to eq("<mstyle mathvariant=\"double-struck\"><mi>C</mi></mstyle>")
      end

      it "matches HTML string" do
        expect(klass.to_html).to eq("&#x2102;")
      end
    end
  end
end
