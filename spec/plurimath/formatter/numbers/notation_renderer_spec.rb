# frozen_string_literal: true

require "spec_helper"
require_relative "../../../support/shared_formatter_examples"

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
      expect_shared_formatter_output("notation-renderer-035", result.to_s)
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
      expect_shared_formatter_output("notation-renderer-056", result.to_s)
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
      expect_shared_formatter_output("notation-renderer-074", result.to_s)
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
      expect_shared_formatter_output("notation-renderer-090", result1.to_s)

      result2 = renderer.render(source("1.23e4"), :engineering)
      expect_shared_formatter_output("notation-renderer-093", result2.to_s)
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
      expect_shared_formatter_output("notation-renderer-106", result.to_s)
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
      expect_shared_formatter_output("notation-renderer-120", result.coefficient.to_s)
    end
  end
end
