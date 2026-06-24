# frozen_string_literal: true

require "spec_helper"

RSpec.describe Plurimath::Formatter::Numbers::FormattedNotation do
  let(:decimal_notation) do
    Plurimath::Formatter::Numbers::BaseNotation.new(base: 10)
  end

  let(:hex_coefficient) do
    Plurimath::Formatter::Numbers::FormattedNumber.new(
      sign: 1, integer_part: "ff", fraction_part: "",
      decimal_separator: ".", base_notation: Plurimath::Formatter::Numbers::BaseNotation.new(base: 16, prefix: "0x")
    )
  end

  let(:decimal_coefficient) do
    Plurimath::Formatter::Numbers::FormattedNumber.new(
      sign: 1, integer_part: "1.40", fraction_part: "",
      decimal_separator: ".", base_notation: decimal_notation
    )
  end

  describe "#to_s" do
    it "renders e notation with exponent separator" do
      notation = described_class.new(
        coefficient: decimal_coefficient,
        notation_style: :e,
        exponent: 4,
        exponent_separator: "e",
      )

      expect(notation.to_s).to eq("1.40e4")
    end

    it "renders e notation with custom exponent separator" do
      notation = described_class.new(
        coefficient: decimal_coefficient,
        notation_style: :e,
        exponent: 4,
        exponent_separator: "E",
      )

      expect(notation.to_s).to eq("1.40E4")
    end

    it "renders scientific notation with times symbol" do
      notation = described_class.new(
        coefficient: decimal_coefficient,
        notation_style: :scientific,
        exponent: 4,
        times_symbol: "×",
      )

      expect(notation.to_s).to eq("1.40 × 10^4")
    end

    it "renders engineering notation with times symbol" do
      notation = described_class.new(
        coefficient: Plurimath::Formatter::Numbers::FormattedNumber.new(
          sign: 1, integer_part: "14,00", fraction_part: "",
          decimal_separator: ",", base_notation: decimal_notation
        ),
        notation_style: :engineering,
        exponent: 3,
        times_symbol: "x",
      )

      expect(notation.to_s).to eq("14,00 x 10^3")
    end

    it "renders negative exponents correctly" do
      notation = described_class.new(
        coefficient: decimal_coefficient,
        notation_style: :scientific,
        exponent: -3,
        times_symbol: "×",
      )

      expect(notation.to_s).to eq("1.40 × 10^-3")
    end

    it "renders zero exponent as 0" do
      notation = described_class.new(
        coefficient: decimal_coefficient,
        notation_style: :scientific,
        exponent: 0,
        times_symbol: "×",
      )

      expect(notation.to_s).to eq("1.40 × 10^0")
    end
  end

  describe "#to_str" do
    it "delegates to to_s" do
      notation = described_class.new(
        coefficient: decimal_coefficient,
        notation_style: :e,
        exponent: 4,
      )

      expect(notation.to_str).to eq(notation.to_s)
    end
  end

  describe "#formatted_exponent" do
    it "returns 0 for zero exponent" do
      notation = described_class.new(
        coefficient: decimal_coefficient,
        notation_style: :e,
        exponent: 0,
      )

      expect(notation.formatted_exponent).to eq("0")
    end

    it "returns the exponent as a string for positive values" do
      notation = described_class.new(
        coefficient: decimal_coefficient,
        notation_style: :e,
        exponent: 4,
      )

      expect(notation.formatted_exponent).to eq("4")
    end

    it "prepends minus for negative exponents" do
      notation = described_class.new(
        coefficient: decimal_coefficient,
        notation_style: :e,
        exponent: -3,
      )

      expect(notation.formatted_exponent).to eq("-3")
    end

    it "prepends plus when exponent_sign is :plus and exponent is positive" do
      notation = described_class.new(
        coefficient: decimal_coefficient,
        notation_style: :e,
        exponent: 4,
        exponent_sign: :plus,
      )

      expect(notation.formatted_exponent).to eq("+4")
    end

    it "does not prepend plus when exponent_sign is :plus but exponent is negative" do
      notation = described_class.new(
        coefficient: decimal_coefficient,
        notation_style: :e,
        exponent: -3,
        exponent_sign: :plus,
      )

      expect(notation.formatted_exponent).to eq("-3")
    end

    it "does not prepend plus when exponent_sign is nil" do
      notation = described_class.new(
        coefficient: decimal_coefficient,
        notation_style: :e,
        exponent: 4,
        exponent_sign: nil,
      )

      expect(notation.formatted_exponent).to eq("4")
    end
  end

  describe "#base_notation?" do
    it "returns true when the coefficient has base notation" do
      notation = described_class.new(
        coefficient: hex_coefficient,
        notation_style: :e,
        exponent: 2,
      )

      expect(notation).to be_base_notation
    end

    it "returns false when the coefficient is decimal" do
      notation = described_class.new(
        coefficient: decimal_coefficient,
        notation_style: :e,
        exponent: 4,
      )

      expect(notation).not_to be_base_notation
    end
  end

  describe "attribute accessors" do
    it "exposes coefficient as FormattedNumber" do
      notation = described_class.new(
        coefficient: decimal_coefficient,
        notation_style: :scientific,
        exponent: 4,
        times_symbol: "×",
        exponent_separator: "e",
        exponent_sign: :plus,
      )

      expect(notation.coefficient).to eq(decimal_coefficient)
      expect(notation.notation_style).to eq(:scientific)
      expect(notation.exponent).to eq(4)
      expect(notation.times_symbol).to eq("×")
      expect(notation.exponent_separator).to eq("e")
      expect(notation.exponent_sign).to eq(:plus)
    end
  end
end
