# frozen_string_literal: true

require "spec_helper"

RSpec.describe Plurimath::Formatter::Numbers::Source do
  describe "#to_parts" do
    it "keeps the raw value and decimal interpretation together" do
      source = described_class.new("0123")

      expect(source.raw).to eq("0123")
      expect(source.decimal).to eq(BigDecimal("123"))
    end

    it "normalizes exponent notation into decimal parts" do
      parts = described_class.new("1.230e2").to_parts

      expect(parts.sign).to eq(1)
      expect(parts.integer_digits).to eq("123")
      expect(parts.fraction_digits).to eq("0")
      expect(parts).to be_fractional
      expect(parts.to_s).to eq("123.0")
    end

    it "preserves negative signs separately from digits" do
      parts = described_class.new("-.0010e+2").to_parts

      expect(parts.sign).to eq(-1)
      expect(parts.integer_digits).to eq("0")
      expect(parts.fraction_digits).to eq("10")
      expect(parts.to_s).to eq("-0.10")
    end

    it "pads fractional digits for negative exponents" do
      parts = described_class.new("1e-3").to_parts

      expect(parts.integer_digits).to eq("0")
      expect(parts.fraction_digits).to eq("001")
      expect(parts.significant_digit_count).to eq(1)
    end

    it "uses the default base when no base is provided" do
      parts = described_class.new("15").to_parts(base: nil)

      expect(parts.base).to eq(10)
    end

    it "applies precision to normalized fraction digits" do
      parts = described_class.new("1.234e-1").to_parts(precision: 2)

      expect(parts.integer_digits).to eq("0")
      expect(parts.fraction_digits).to eq("12")
    end

    it "removes fraction digits for zero precision" do
      parts = described_class.new("12.34").to_parts(precision: 0)

      expect(parts.integer_digits).to eq("12")
      expect(parts.fraction_digits).to eq("")
    end
  end

  describe "#fractional?" do
    it "matches existing exponent-aware fractional detection" do
      expect(described_class.new("0.123e3")).not_to be_fractional
      expect(described_class.new("0.12325e3")).to be_fractional
      expect(described_class.new("1e-3")).to be_fractional
    end
  end

  describe "#decimal_precision" do
    it "uses normalized decimal parts instead of raw exponent text" do
      expect(described_class.new("123.450").decimal_precision).to eq(3)
      expect(described_class.new("1.230e2").decimal_precision).to eq(1)
      expect(described_class.new("0.123e3").decimal_precision).to eq(0)
    end
  end

  describe "#notation_precision" do
    it "counts coefficient digits from parsed source digits" do
      expect(described_class.new("14000").notation_precision).to eq(4)
      expect(described_class.new("1.23e4").notation_precision).to eq(2)
    end

    it "ignores the sign when counting coefficient digits" do
      expect(described_class.new("-14000").notation_precision).to eq(4)
    end

    it "preserves zero scale for notation rendering" do
      expect(described_class.new("0.00").notation_precision).to eq(2)
    end
  end

  describe "#significant_digit_count" do
    it "counts source significant digits before BigDecimal can drop zeros" do
      source = described_class.new("001.2300e2")

      expect(source.significant_digit_count).to eq(5)
      expect(source.trailing_fraction_zero_count).to eq(2)
    end
  end

  describe "#target_base_integer_length" do
    it "returns zero for fractional values with no integer digits" do
      expect(described_class.new("0.1").target_base_integer_length(16)).to eq(0)
    end

    it "calculates the converted integer length for supported target bases" do
      expect(described_class.new("255.5").target_base_integer_length(16)).to eq(2)
      expect(described_class.new("8").target_base_integer_length(2)).to eq(4)
    end
  end
end
