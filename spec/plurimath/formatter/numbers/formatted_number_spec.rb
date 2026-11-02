# frozen_string_literal: true

require "spec_helper"
require_relative "../../../support/shared_formatter_examples"

RSpec.describe Plurimath::Formatter::Numbers::FormattedNumber do
  let(:base_notation) { Plurimath::Formatter::Numbers::BaseNotation.new(base: 10) }
  let(:hex_notation) { Plurimath::Formatter::Numbers::BaseNotation.new(base: 16, prefix: "0x") }

  describe "#to_s" do
    it "renders a plain integer" do
      result = described_class.new(
        sign: 1, integer_part: "1,000", fraction_part: "",
        decimal_separator: ".", base_notation: base_notation
      )

      expect_shared_formatter_output("formatted-number-016", result.to_s)
    end

    it "renders a decimal number" do
      result = described_class.new(
        sign: 1, integer_part: "1", fraction_part: "234",
        decimal_separator: ".", base_notation: base_notation
      )

      expect_shared_formatter_output("formatted-number-025", result.to_s)
    end

    it "renders a negative number" do
      result = described_class.new(
        sign: -1, integer_part: "42", fraction_part: "",
        decimal_separator: ".", base_notation: base_notation
      )

      expect_shared_formatter_output("formatted-number-034", result.to_s)
    end

    it "renders a positive number with explicit plus sign" do
      result = described_class.new(
        sign: 1, integer_part: "42", fraction_part: "",
        decimal_separator: ".", base_notation: base_notation,
        number_sign: :plus
      )

      expect_shared_formatter_output("formatted-number-044", result.to_s)
    end

    it "wraps digits with base prefix and postfix" do
      result = described_class.new(
        sign: 1, integer_part: "ff", fraction_part: "",
        decimal_separator: ".", base_notation: hex_notation
      )

      expect_shared_formatter_output("formatted-number-053", result.to_s)
    end

    it "applies sign before base notation for negative numbers" do
      result = described_class.new(
        sign: -1, integer_part: "ff", fraction_part: "",
        decimal_separator: ".", base_notation: hex_notation
      )

      expect_shared_formatter_output("formatted-number-062", result.to_s)
    end

    it "uppercases hex digits when hex_capital is true" do
      upcase_notation = Plurimath::Formatter::Numbers::BaseNotation.new(
        base: 16, prefix: "0x", hex_capital: true,
      )
      result = described_class.new(
        sign: 1, integer_part: "a.d'f", fraction_part: "",
        decimal_separator: ".", base_notation: upcase_notation
      )

      expect_shared_formatter_output("formatted-number-074", result.to_s)
    end

    it "combines prefix, postfix, decimal, and sign" do
      combined = Plurimath::Formatter::Numbers::BaseNotation.new(
        base: 16, prefix: "16#", postfix: "_16",
      )
      result = described_class.new(
        sign: -1, integer_part: "BE,EF", fraction_part: "",
        decimal_separator: ".", base_notation: combined
      )

      expect_shared_formatter_output("formatted-number-086", result.to_s)
    end
  end

  describe "#negative?" do
    it "returns true for negative sign" do
      result = described_class.new(
        sign: -1, integer_part: "1", fraction_part: "",
        decimal_separator: ".", base_notation: base_notation
      )

      expect(result).to be_negative
    end

    it "returns false for positive sign" do
      result = described_class.new(
        sign: 1, integer_part: "1", fraction_part: "",
        decimal_separator: ".", base_notation: base_notation
      )

      expect(result).not_to be_negative
    end
  end

  describe "#fractional?" do
    it "returns true when fraction_part is present" do
      result = described_class.new(
        sign: 1, integer_part: "1", fraction_part: "5",
        decimal_separator: ".", base_notation: base_notation
      )

      expect(result).to be_fractional
    end

    it "returns false when fraction_part is empty" do
      result = described_class.new(
        sign: 1, integer_part: "1", fraction_part: "",
        decimal_separator: ".", base_notation: base_notation
      )

      expect(result).not_to be_fractional
    end
  end

  describe "#base_notation?" do
    it "returns false for base 10" do
      result = described_class.new(
        sign: 1, integer_part: "42", fraction_part: "",
        decimal_separator: ".", base_notation: base_notation
      )

      expect(result).not_to be_base_notation
    end

    it "returns true for non-decimal bases" do
      result = described_class.new(
        sign: 1, integer_part: "ff", fraction_part: "",
        decimal_separator: ".", base_notation: hex_notation
      )

      expect(result).to be_base_notation
    end
  end

  describe "#sign_text" do
    it "returns minus for negative numbers" do
      result = described_class.new(
        sign: -1, integer_part: "42", fraction_part: "",
        decimal_separator: ".", base_notation: base_notation
      )

      expect_shared_formatter_output("formatted-number-157", result.sign_text)
    end

    it "returns plus when number_sign is :plus" do
      result = described_class.new(
        sign: 1, integer_part: "42", fraction_part: "",
        decimal_separator: ".", base_notation: base_notation,
        number_sign: :plus
      )

      expect_shared_formatter_output("formatted-number-167", result.sign_text)
    end

    it "returns nil for positive numbers without explicit sign" do
      result = described_class.new(
        sign: 1, integer_part: "42", fraction_part: "",
        decimal_separator: ".", base_notation: base_notation
      )

      expect_shared_formatter_output("formatted-number-176", result.sign_text)
    end

    it "prefers minus over plus when negative with number_sign :plus" do
      result = described_class.new(
        sign: -1, integer_part: "42", fraction_part: "",
        decimal_separator: ".", base_notation: base_notation,
        number_sign: :plus
      )

      expect_shared_formatter_output("formatted-number-186", result.sign_text)
    end
  end

  describe "#digits_string" do
    it "returns digits without sign, prefix, or postfix" do
      combined = Plurimath::Formatter::Numbers::BaseNotation.new(
        base: 16, prefix: "0x", postfix: "_h",
      )
      result = described_class.new(
        sign: -1, integer_part: "BE,EF", fraction_part: "",
        decimal_separator: ".", base_notation: combined
      )

      expect_shared_formatter_output("formatted-number-200", result.digits_string)
    end

    it "includes the decimal separator and fraction when present" do
      result = described_class.new(
        sign: 1, integer_part: "1", fraction_part: "5",
        decimal_separator: ".", base_notation: base_notation
      )

      expect_shared_formatter_output("formatted-number-209", result.digits_string)
    end

    it "uppercases hex digits when hex_capital is true" do
      upcase_notation = Plurimath::Formatter::Numbers::BaseNotation.new(
        base: 16, prefix: "0x", hex_capital: true,
      )
      result = described_class.new(
        sign: 1, integer_part: "be", fraction_part: "ef",
        decimal_separator: ".", base_notation: upcase_notation
      )

      expect_shared_formatter_output("formatted-number-221", result.digits_string)
    end
  end

  describe "structured access for downstream rendering" do
    it "exposes base for subscript rendering" do
      result = described_class.new(
        sign: 1, integer_part: "ff", fraction_part: "",
        decimal_separator: ".", base_notation: hex_notation
      )

      expect(result.base_notation.base).to eq(16)
      expect_shared_formatter_output("formatted-number-233", result.digits_string)
    end

    it "exposes sign for output format rendering" do
      result = described_class.new(
        sign: -1, integer_part: "1010", fraction_part: "",
        decimal_separator: ".",
        base_notation: Plurimath::Formatter::Numbers::BaseNotation.new(base: 2, prefix: "0b")
      )

      expect(result).to be_negative
      expect(result.base_notation.base).to eq(2)
      expect_shared_formatter_output("formatted-number-245", result.digits_string)
    end
  end
end
