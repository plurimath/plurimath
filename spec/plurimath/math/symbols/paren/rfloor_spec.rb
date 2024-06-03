require "spec_helper"

RSpec.describe Plurimath::Math::Symbols::Paren::Rfloor do

  describe ".initialize" do
    it 'returns instance of paren symbol Rfloor' do
      klass = described_class.new
      expect(klass).to be_a(Plurimath::Math::Symbols::Paren::Rfloor)
    end
  end

  describe ".open?, .close?, .opening" do
    subject(:klass) { described_class.new }

    context "matches if open paren for the Symbol Plurimath::Math::Symbols::Paren::Rfloor" do
      it "matches if paren is open" do
        expect(klass.open?).to eq(false)
      end

      it "checks if paren is closing paren" do
        expect(klass.close?).to eq(true)
      end
      it "checks if paren is open" do
        expect(klass.opening).to eq(Plurimath::Math::Symbols::Paren::Lfloor)
      end
    end
  end

  describe "All language conversion specs" do
    subject(:klass) { described_class.new }

    context "Matches all conversion for the Symbol Plurimath::Math::Symbols::Paren::Rfloor" do
      it "matches AsciiMath paren string" do
        expect(klass.to_asciimath).to eq("__|")
      end

      it "matches LaTeX paren string" do
        expect(klass.to_latex).to eq("\\rfloor")
      end

      it "matches UnicodeMath paren string" do
        expect(klass.to_unicodemath).to eq("⌋")
      end

      it "matches OMML paren string" do
        expect(klass.to_omml_without_math_tag(true)).to eq("&#x230b;")
      end

      it "matches MathML paren string" do
        string = dump_ox_nodes(klass.to_mathml_without_math_tag).strip
        expect(string).to eq("<mo>⌋</mo>")
      end

      it "matches HTML paren string" do
        expect(klass.to_html).to eq("&#x230b;")
      end
    end
  end
end
