# frozen_string_literal: true

require "spec_helper"

RSpec.describe Plurimath::Formatter::Numbers::NotationRenderer do
  def options(symbols)
    Plurimath::Formatter::Numbers::FormatOptions.new(symbols: symbols)
  end

  def source(number_string)
    Plurimath::Formatter::Numbers::Source.new(number_string)
  end

  describe ".supported?" do
    it "reports supported notation values" do
      expect(described_class.supported?(:scientific)).to be(true)
      expect(described_class.supported?(:basic)).to be(false)
    end
  end

  describe "#render" do
    it "returns a FormattedNotation for e notation" do
      renderer = described_class.new(
        options(
          decimal: "@",
          precision: 1,
          e: :E,
          times: "x",
        ),
      )

      result = renderer.render(source("14000"), :e)

      expect(result).to be_a(Plurimath::Formatter::Numbers::FormattedNotation)
      expect(result.to_s).to eq("1@4E4")
      expect(result.notation_style).to eq(:e)
      expect(result.exponent).to eq(4)
    end

    it "returns a FormattedNotation for scientific notation" do
      renderer = described_class.new(
        options(
          decimal: ".",
          fraction_group: " ",
          fraction_group_digits: 3,
          precision: 4,
          exponent_sign: :plus,
          e: :e,
          times: "\u{d7}",
        ),
      )

      result = renderer.render(source("14000"), :scientific)

      expect(result).to be_a(Plurimath::Formatter::Numbers::FormattedNotation)
      expect(result.to_s).to eq("1.400 0 × 10^+4")
      expect(result.notation_style).to eq(:scientific)
      expect(result.exponent).to eq(4)
    end

    it "returns a FormattedNotation for engineering notation" do
      renderer = described_class.new(
        options(
          decimal: ",",
          precision: 2,
          e: :e,
          times: :x,
        ),
      )

      result = renderer.render(source("14000"), :engineering)

      expect(result).to be_a(Plurimath::Formatter::Numbers::FormattedNotation)
      expect(result.to_s).to eq("14,00 x 10^3")
      expect(result.notation_style).to eq(:engineering)
      expect(result.exponent).to eq(3)
    end

    it "infers engineering precision from significant digits instead of raw characters" do
      renderer = described_class.new(
        options(
          decimal: ".",
          precision: 0,
          e: :e,
          times: :x,
        ),
      )

      result1 = renderer.render(source("-14000"), :engineering)
      expect(result1.to_s).to eq("-14.000 x 10^3")

      result2 = renderer.render(source("1.23e4"), :engineering)
      expect(result2.to_s).to eq("12.3 x 10^3")
    end

    it "preserves zero precision in scientific notation" do
      renderer = described_class.new(
        options(
          precision: 2,
          e: :e,
          times: "\u{d7}",
        ),
      )

      result = renderer.render(source("0.00"), :scientific)
      expect(result.to_s).to eq("0.00 × 10^0")
    end

    it "carries the coefficient as a FormattedNumber" do
      renderer = described_class.new(
        options(
          precision: 2,
          e: :e,
          times: "x",
        ),
      )

      result = renderer.render(source("14000"), :scientific)
      expect(result.coefficient).to be_a(Plurimath::Formatter::Numbers::FormattedNumber)
      expect(result.coefficient.to_s).to eq("1.40")
    end
  end
end
