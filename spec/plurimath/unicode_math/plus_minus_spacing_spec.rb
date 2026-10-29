require "spec_helper"

RSpec.describe Plurimath::UnicodeMath::Parser do
  def parse(string)
    described_class.new(string).parse
  end

  describe "plus-minus and minus-plus with surrounding spaces" do
    it "parses `1.23 ± 0.04` as number, plus-minus, number" do
      formula = parse("1.23 ± 0.04")

      expected = [
        Plurimath::Math::Number.new("1.23"),
        Plurimath::Math::Symbols::Pm.new,
        Plurimath::Math::Number.new("0.04"),
      ]

      expect(formula).to eq(Plurimath::Math::Formula.new(expected))
      expect(formula.to_asciimath).to eq("1.23 pm 0.04")
    end

    {
      "1.23 ± 0.04" => "1.23±0.04",
      "a ± b" => "a±b",
      "x ∓ y" => "x∓y",
    }.each do |spaced, unspaced|
      it "parses `#{spaced}` the same as `#{unspaced}`" do
        expect(parse(spaced)).to eq(parse(unspaced))
      end
    end

    it "keeps parsing the unspaced `a±b`" do
      expect(parse("a±b").to_asciimath).to eq("a pm b")
    end

    it "parses `x ∓ y` with a minus-plus symbol" do
      expect(parse("x ∓ y").value.map(&:class)).to eq(
        [
          Plurimath::Math::Symbols::Symbol,
          Plurimath::Math::Symbols::Mp,
          Plurimath::Math::Symbols::Symbol,
        ],
      )
    end

    it "round-trips AsciiMath `1.23 +- 0.04` through UnicodeMath" do
      asciimath = Plurimath::Math.parse("1.23 +- 0.04", :asciimath)
      unicodemath = asciimath.to_unicodemath

      expect(unicodemath).to eq("1.23 ± 0.04")
      expect(Plurimath::Math.parse(unicodemath, :unicode)).to eq(asciimath)
    end
  end
end
