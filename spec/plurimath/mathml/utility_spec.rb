require "spec_helper"

RSpec.describe Plurimath::Mathml::Utility do
  def parse_mathml(body)
    Plurimath::Mathml::Parser.new(<<~MATHML).parse
      <math xmlns="http://www.w3.org/1998/Math/MathML">#{body}</math>
    MATHML
  end

  describe ".resolve_token" do
    it "resolves unicode function characters to function instances" do
      expect(described_class.resolve_token("∑"))
        .to eq(Plurimath::Math::Function::Sum.new)
    end

    it "resolves representation-free named function words" do
      aggregate_failures do
        expect(described_class.resolve_token("sin"))
          .to eq(Plurimath::Math::Function::Sin.new)
        expect(described_class.resolve_token("min"))
          .to eq(Plurimath::Math::Function::Min.new)
        expect(described_class.resolve_token("mod"))
          .to eq(Plurimath::Math::Function::Mod.new)
      end
    end

    it "keeps structurally represented words as literal symbols" do
      aggregate_failures do
        expect(described_class.resolve_token("frac"))
          .to eq(Plurimath::Math::Symbols::Symbol.new("frac"))
        expect(described_class.resolve_token("sqrt"))
          .to eq(Plurimath::Math::Symbols::Symbol.new("sqrt"))
        expect(described_class.resolve_token("sum"))
          .to eq(Plurimath::Math::Symbols::Symbol.new("sum"))
        expect(described_class.resolve_token("bar"))
          .to eq(Plurimath::Math::Symbols::Symbol.new("bar"))
      end
    end

    it "wraps unknown words in literal symbols" do
      expect(described_class.resolve_token("hello"))
        .to eq(Plurimath::Math::Symbols::Symbol.new("hello"))
    end

    it "keeps already-encoded entity strings on the symbol fallback path" do
      expect(described_class.resolve_token("&#x2211;"))
        .to eq(Plurimath::Math::Symbols::Symbol.new("&#x26;#x2211;"))
    end

    it "returns nil for nil input" do
      expect(described_class.resolve_token(nil)).to be_nil
    end
  end

  describe "parser integration" do
    it "resolves bare named function words through Mathml::Utility" do
      expect(parse_mathml("<mi>sin</mi>"))
        .to eq(Plurimath::Math::Formula.new([Plurimath::Math::Function::Sin.new]))
    end

    it "keeps structurally represented words literal" do
      expected = Plurimath::Math::Formula.new(
        [Plurimath::Math::Symbols::Symbol.new("frac")],
      )

      expect(parse_mathml("<mi>frac</mi>"))
        .to eq(expected)
    end

    it "resolves unicode function characters through Mathml::Utility" do
      expect(parse_mathml("<mo>&#x2211;</mo>"))
        .to eq(Plurimath::Math::Formula.new([Plurimath::Math::Function::Sum.new]))
    end
  end
end
