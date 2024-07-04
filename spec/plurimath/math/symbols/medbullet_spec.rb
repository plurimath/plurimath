require "spec_helper"

RSpec.describe Plurimath::Math::Symbols::Medbullet do

  describe ".initialize" do
    it 'returns instance of Symbol Medbullet' do
      klass = described_class.new
      expect(klass).to be_a(Plurimath::Math::Symbols::Medbullet)
    end
  end

  describe "All language conversion specs" do
    subject(:klass) { described_class.new }

    context "Matches all conversion for the Symbol Plurimath::Math::Symbols::Medbullet" do
      it "matches AsciiMath string" do
        expect(klass.to_asciimath).to eq("\"P{medbullet}\"")
      end

      it "matches LaTeX string" do
        expect(klass.to_latex).to eq("\\mdblkcircle")
      end

      it "matches UnicodeMath string" do
        expect(klass.to_unicodemath).to eq("⚫")
      end

      it "matches OMML string" do
        expect(klass.to_omml_without_math_tag(true)).to eq("&#x26ab;")
      end

      it "matches MathML string" do
        string = dump_ox_nodes(klass.to_mathml_without_math_tag(false)).strip
        expect(string).to eq("<mi>&#x26ab;</mi>")
      end

      it "matches HTML string" do
        expect(klass.to_html).to eq("&#x26ab;")
      end
    end
  end
end
