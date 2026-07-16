require "spec_helper"

# Characterization specs (phase A0 of the language-utility split).
#
# These examples pin the CURRENT behavior of the AsciiMath-side table/symbol
# helpers before they move to language-specific utility modules.
# Expectations were derived by running the code, not from intent — oddities
# are pinned as-is and flagged with `# quirk:` comments rather than "fixed".
RSpec.describe Plurimath::Asciimath::Utility do
  def number(value)
    Plurimath::Math::Number.new(value)
  end

  def td(values, options = nil)
    Plurimath::Math::Function::Td.new(values, options)
  end

  def slice(string)
    Parslet::Slice.new(Parslet::Position.new(string, 0), string)
  end

  describe ".td_values" do
    it "slices objects into Tds on Comma with a ',' slicer" do
      result = described_class.td_values(
        [number("1"), Plurimath::Math::Symbols::Comma.new, number("2")],
        ",",
      )

      expect(result).to eq([td([number("1")]), td([number("2")])])
    end

    it "slices on a generic Symbol whose value is the slicer" do
      result = described_class.td_values(
        [number("1"), Plurimath::Math::Symbols::Symbol.new(","), number("2")],
        ",",
      )

      expect(result).to eq([td([number("1")]), td([number("2")])])
    end

    # Regression: a Symbol whose value merely CONTAINS the slicer is not the
    # separator, so it stays as cell content instead of slicing the row.
    it "keeps a Symbol whose value only contains the slicer as content" do
      symbol = Plurimath::Math::Symbols::Symbol.new("a,b")
      result = described_class.td_values(
        [number("1"), symbol, number("2")],
        ",",
      )

      expect(result).to eq([td([number("1"), symbol, number("2")])])
    end

    # quirk: a trailing separator appends an extra empty Td.
    it "appends an empty Td when the last object is a separator" do
      result = described_class.td_values(
        [number("1"), Plurimath::Math::Symbols::Comma.new],
        ",",
      )

      expect(result).to eq([td([number("1")]), td([])])
    end

    it "returns a single Td when no separator is present" do
      result = described_class.td_values([number("1"), number("2")], ",")

      expect(result).to eq([td([number("1"), number("2")])])
    end

    it "returns an empty array for empty input" do
      expect(described_class.td_values([], ",")).to eq([])
    end
  end

  describe ".td_value" do
    it "converts an empty String to Text.new(nil)" do
      expect(described_class.td_value("")).to eq(
        Plurimath::Math::Function::Text.new(nil),
      )
    end

    it "converts an empty Parslet::Slice to Text.new(nil)" do
      expect(described_class.td_value(slice(""))).to eq(
        Plurimath::Math::Function::Text.new(nil),
      )
    end

    it "returns a non-empty String unchanged" do
      input = "abc"

      expect(described_class.td_value(input)).to be(input)
    end

    it "returns a non-empty Parslet::Slice unchanged" do
      input = slice("x")
      result = described_class.td_value(input)

      expect(result).to be(input)
      expect(result).to be_a(Parslet::Slice)
    end

    it "returns non-string objects unchanged" do
      input = Plurimath::Math::Formula.new([number("1")])

      expect(described_class.td_value(input)).to be(input)
    end
  end

  describe ".frac_values" do
    it "returns true for a Formula containing a Comma" do
      formula = Plurimath::Math::Formula.new(
        [number("1"), Plurimath::Math::Symbols::Comma.new, number("2")],
      )

      expect(described_class.frac_values(formula)).to be(true)
    end

    it "returns false for a Formula without a Comma" do
      formula = Plurimath::Math::Formula.new([number("1")])

      expect(described_class.frac_values(formula)).to be(false)
    end

    it "returns false for an empty Formula" do
      expect(described_class.frac_values(Plurimath::Math::Formula.new([]))).to be(false)
    end

    it "returns true for an Array containing a Comma" do
      array = [number("1"), Plurimath::Math::Symbols::Comma.new]

      expect(described_class.frac_values(array)).to be(true)
    end

    it "returns false for an Array without a Comma" do
      expect(described_class.frac_values([number("1")])).to be(false)
    end

    # quirk: the case statement has no else branch, so anything that is not
    # a Formula or an Array (including nil) yields nil rather than false.
    it "returns nil for non-Formula, non-Array input" do
      expect(described_class.frac_values(number("1"))).to be_nil
      expect(described_class.frac_values(nil)).to be_nil
    end
  end

  describe ".asciimath_symbol_object" do
    it "returns nil for nil input" do
      expect(described_class.asciimath_symbol_object(nil)).to be_nil
    end

    it "resolves a known symbol name to its symbol class" do
      expect(described_class.asciimath_symbol_object("alpha")).to eq(
        Plurimath::Math::Symbols::Alpha.new,
      )
      expect(described_class.asciimath_symbol_object("+")).to eq(
        Plurimath::Math::Symbols::Plus.new,
      )
      expect(described_class.asciimath_symbol_object(",")).to eq(
        Plurimath::Math::Symbols::Comma.new,
      )
    end

    it "accepts Parslet::Slice input" do
      expect(described_class.asciimath_symbol_object(slice("alpha"))).to eq(
        Plurimath::Math::Symbols::Alpha.new,
      )
    end

    it "falls back to paren classes for paren tokens" do
      expect(described_class.asciimath_symbol_object("(")).to eq(
        Plurimath::Math::Symbols::Paren::Lround.new,
      )
    end

    # quirk: the special glyphs ℒ and ℛ are remapped (via symbol_object) to
    # the "{:" / ":}" open/close paren classes.
    it "remaps ℒ and ℛ to OpenParen and CloseParen" do
      expect(described_class.asciimath_symbol_object("ℒ")).to eq(
        Plurimath::Math::Symbols::Paren::OpenParen.new,
      )
      expect(described_class.asciimath_symbol_object("ℛ")).to eq(
        Plurimath::Math::Symbols::Paren::CloseParen.new,
      )
    end

    # quirk: function words like "sum" are not in the asciimath symbols
    # table, so they come back as a generic Symbol with the literal value
    # rather than the Sum function class.
    it "wraps unknown tokens in a generic Symbol carrying the value" do
      expect(described_class.asciimath_symbol_object("sum")).to eq(
        Plurimath::Math::Symbols::Symbol.new("sum"),
      )
      expect(described_class.asciimath_symbol_object("zzznotasymbol")).to eq(
        Plurimath::Math::Symbols::Symbol.new("zzznotasymbol"),
      )
    end
  end
end
