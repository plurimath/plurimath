require "spec_helper"

# Characterization specs for the display/serialization helpers extracted from
# Plurimath::Utility into Plurimath::Math::ModelHelper (macro refactor). Known
# quirks remain pinned as-is with "# quirk:" comments; behavior changes belong
# in a later, separate PR together with the production-code change.
RSpec.describe Plurimath::Math::ModelHelper do
  describe ".validate_left_right" do
    it "flags formulas whose first value is Function::Left" do
      formula = Plurimath::Math::Formula.new(
        [Plurimath::Math::Function::Left.new("("), Plurimath::Math::Number.new("2")],
      )
      # Formula#initialize resets the wrapper to false when it starts with Left
      expect(formula.left_right_wrapper).to be(false)

      described_class.validate_left_right([formula])
      expect(formula.left_right_wrapper).to be(true)
    end

    it "returns the fields array itself, tolerating nils and non-formulas" do
      formula = Plurimath::Math::Formula.new(
        [Plurimath::Math::Function::Left.new("("), Plurimath::Math::Number.new("2")],
      )
      fields = [formula, nil, Plurimath::Math::Number.new("3")]

      result = described_class.validate_left_right(fields)
      expect(result).to be(fields)
      expect(result.length).to eq(3)
    end

    it "leaves formulas not starting with Function::Left untouched" do
      formula = Plurimath::Math::Formula.new([Plurimath::Math::Number.new("2")], false)
      described_class.validate_left_right([formula])
      expect(formula.left_right_wrapper).to be(false)
    end

    it "returns an empty array when called with no fields" do
      expect(described_class.validate_left_right).to eq([])
    end
  end

  describe ".validate_math_zone" do
    it "returns false for nil" do
      expect(described_class.validate_math_zone(nil, lang: :asciimath)).to be(false)
    end

    it "returns false for text-classed objects (number)" do
      expect(described_class.validate_math_zone(Plurimath::Math::Number.new("2"), lang: :asciimath)).to be(false)
    end

    it "returns false for text-classed objects (text)" do
      expect(described_class.validate_math_zone(Plurimath::Math::Function::Text.new("hi"), lang: :asciimath)).to be(false)
    end

    it "returns false for symbols" do
      expect(described_class.validate_math_zone(Plurimath::Math::Symbols::Symbol.new("x"), lang: :asciimath)).to be(false)
    end

    it "returns true for non-text objects such as Frac" do
      frac = Plurimath::Math::Function::Frac.new(
        Plurimath::Math::Number.new("1"), Plurimath::Math::Number.new("2")
      )
      expect(described_class.validate_math_zone(frac, lang: :asciimath)).to be(true)
    end

    # quirk: the formula branch returns Enumerable#find results, so an
    # all-text formula yields nil (falsy) rather than false
    it "returns nil for a formula containing only text-like values" do
      formula = Plurimath::Math::Formula.new(
        [Plurimath::Math::Symbols::Symbol.new("a"), Plurimath::Math::Number.new("1")],
      )
      expect(described_class.validate_math_zone(formula, lang: :asciimath)).to be_nil
    end

    it "returns nil for an empty formula" do
      expect(described_class.validate_math_zone(Plurimath::Math::Formula.new([]), lang: :asciimath)).to be_nil
    end

    # quirk: for a formula the found object (a dup, not the original instance)
    # is returned, not true
    it "returns a dup of the first non-text value for a mixed formula" do
      frac = Plurimath::Math::Function::Frac.new(
        Plurimath::Math::Number.new("1"), Plurimath::Math::Number.new("2")
      )
      formula = Plurimath::Math::Formula.new(
        [Plurimath::Math::Symbols::Symbol.new("a"), frac],
      )

      result = described_class.validate_math_zone(formula, lang: :asciimath)
      expect(result).to eq(frac)
      expect(result).not_to be(frac)
    end
  end

  describe ".filter_math_zone_values" do
    it "returns an empty array for an empty value" do
      expect(described_class.filter_math_zone_values([], lang: :asciimath)).to eq([])
    end

    # quirk: nil is not guarded (nil&.empty? is falsy), so it crashes
    it "raises NoMethodError for nil" do
      expect { described_class.filter_math_zone_values(nil, lang: :asciimath) }
        .to raise_error(NoMethodError)
    end

    it "merges consecutive text-like values into one space-joined Text" do
      result = described_class.filter_math_zone_values(
        [Plurimath::Math::Symbols::Symbol.new("a"), Plurimath::Math::Symbols::Symbol.new("b")],
        lang: :asciimath,
      )
      expect(result).to eq([Plurimath::Math::Function::Text.new("a b")])
    end

    it "keeps non-text values and flushes pending text before them" do
      frac = Plurimath::Math::Function::Frac.new(
        Plurimath::Math::Number.new("1"), Plurimath::Math::Number.new("2")
      )
      result = described_class.filter_math_zone_values(
        [Plurimath::Math::Symbols::Symbol.new("a"), frac],
        lang: :asciimath,
      )
      expect(result).to eq(
        [Plurimath::Math::Function::Text.new("a"), frac],
      )
    end

    it "uses #value for numbers" do
      result = described_class.filter_math_zone_values(
        [Plurimath::Math::Number.new("42")], lang: :asciimath
      )
      expect(result).to eq([Plurimath::Math::Function::Text.new("42")])
    end

    it "renders generic symbols through the :omml branch of symbol_to_text" do
      result = described_class.filter_math_zone_values(
        [Plurimath::Math::Symbols::Symbol.new("abc")], lang: :omml
      )
      expect(result).to eq([Plurimath::Math::Function::Text.new("abc")])
      expect(result.first.parameter_one).to eq("abc")
    end

    it "renders generic symbols through the :unicodemath branch of symbol_to_text" do
      result = described_class.filter_math_zone_values(
        [Plurimath::Math::Symbols::Symbol.new("abc")], lang: :unicodemath
      )
      expect(result).to eq([Plurimath::Math::Function::Text.new("abc")])
      expect(result.first.parameter_one).to eq("abc")
    end

    it "renders generic symbols through the requested language (latex)" do
      result = described_class.filter_math_zone_values(
        [Plurimath::Math::Symbols::Symbol.new("a")], lang: :latex
      )
      expect(result).to eq([Plurimath::Math::Function::Text.new("a")])
    end

    it "renders generic symbols through the requested language (mathml)" do
      result = described_class.filter_math_zone_values(
        [Plurimath::Math::Symbols::Symbol.new("a"), Plurimath::Math::Symbols::Symbol.new("b")],
        lang: :mathml,
      )
      expect(result).to eq([Plurimath::Math::Function::Text.new("a b")])
    end

    # quirk: only class_name "symbol"/"number"/"text" (plus plus/minus/circ/
    # equal display objects) count as text; named symbol subclasses such as
    # Alpha (class_name "alpha") pass through untouched
    it "passes named symbol subclasses through untouched" do
      result = described_class.filter_math_zone_values(
        [Plurimath::Math::Symbols::Alpha.new], lang: :latex
      )
      expect(result).to eq([Plurimath::Math::Symbols::Alpha.new])
    end

    it "treats display-text symbols like Plus as mergeable text" do
      result = described_class.filter_math_zone_values(
        [Plurimath::Math::Symbols::Plus.new, Plurimath::Math::Number.new("1")],
        lang: :asciimath,
      )
      expect(result).to eq([Plurimath::Math::Function::Text.new("+ 1")])
    end
  end

  describe ".notations_to_mask" do
    it "maps single known notations to their inverted mask" do
      expect(described_class.notations_to_mask("top")).to eq(14)
      expect(described_class.notations_to_mask("bottom")).to eq(13)
      expect(described_class.notations_to_mask("left")).to eq(11)
      expect(described_class.notations_to_mask("horizontalstrike")).to eq(31)
    end

    it "sums multiple notations before inverting the low nibble" do
      expect(described_class.notations_to_mask("top bottom left right")).to eq(0)
      expect(described_class.notations_to_mask("updiagonalstrike downdiagonalstrike")).to eq(207)
    end

    # quirk: a single unknown notation yields nil, and NilClass#^ turns
    # `nil ^ 15` into literal true instead of raising
    it "returns true for a single unknown notation" do
      expect(described_class.notations_to_mask("unknown")).to be(true)
    end

    # quirk: an unknown notation mixed with known ones crashes on nil + Integer
    it "raises NoMethodError when an unknown notation is mixed with known ones" do
      expect { described_class.notations_to_mask("unknown top") }
        .to raise_error(NoMethodError)
    end
  end
end
