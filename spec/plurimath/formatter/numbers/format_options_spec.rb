# frozen_string_literal: true

require "spec_helper"

RSpec.describe Plurimath::Formatter::Numbers::FormatOptions do
  def build_source(number_string)
    Plurimath::Formatter::Numbers::Source.new(number_string)
  end

  describe "#initialize" do
    it "normalizes notation option values" do
      source = build_source("14000")
      symbols = {
        decimal: "@",
        group: "_",
        group_digits: 2,
        base: 16,
        base_prefix: "16#",
        number_sign: :plus,
        notation: "scientific",
        e: "E",
        times: "x",
        exponent_sign: "plus",
      }
      resolver = Plurimath::Formatter::Numbers::PrecisionResolver.new
      options = described_class.new(
        source,
        symbols: symbols,
        precision: nil,
        precision_resolver: resolver,
      )

      expect(options.notation).to eq(:scientific)
      expect(options.exponent_separator).to eq(:E)
      expect(options.times).to eq(:x)
      expect(options.exponent_sign).to eq(:plus)
    end

    it "uses merged symbols for renderer options" do
      options = described_class.new(
        symbols: {
          decimal: "@",
          group: "_",
          group_digits: 2,
          base: 16,
          base_prefix: "16#",
          number_sign: :plus,
        },
      )

      expect(options.decimal).to eq("@")
      expect(options.group).to eq("_")
      expect(options.group_digits).to eq(2)
      expect(options.base).to eq(16)
      expect(options.base_prefix).to eq("16#")
      expect(options).to be_base_prefix
      expect(options.number_sign).to eq(:plus)
    end

    it "resolves precision through PrecisionResolver with source metadata" do
      source = build_source("0.00")
      symbols = {}
      resolver = Plurimath::Formatter::Numbers::PrecisionResolver.new

      options = described_class.new(
        source,
        symbols: symbols,
        precision: nil,
        precision_resolver: resolver,
      )

      expect(options.exponent_separator).to eq(:e)
      expect(options.times).to eq("\u{d7}")
      expect(options.precision).to eq(2)
    end

    it "uses formatter defaults when symbols do not provide values" do
      options = described_class.new(symbols: {})

      expect(options.base).to eq(10)
      expect(options.decimal).to eq(".")
      expect(options.group).to eq(",")
      expect(options.group_digits).to eq(3)
      expect(options.digit_count).to eq(0)
      expect(options.significant).to eq(0)
      expect(options.padding).to eq("0")
      expect(options.padding_digits).to eq(0)
      expect(options.padding_group_digits).to eq(0)
    end

    it "uses configured integer padding options" do
      options = described_class.new(
        symbols: {
          padding: " ",
          padding_digits: 6,
        },
      )

      expect(options.padding).to eq(" ")
      expect(options.padding_digits).to eq(6)
      expect(options.padding_group_digits).to eq(0)
    end

    it "uses only the first configured padding character" do
      options = described_class.new(symbols: { padding: "xy", padding_digits: 4 })

      expect(options.padding).to eq("x")
    end

    it "falls back to zero padding when the configured padding is blank" do
      options = described_class.new(symbols: { padding: "", padding_digits: 4 })

      expect(options.padding).to eq("0")
    end

    it "allows a padding group width when fixed-width padding is absent" do
      options = described_class.new(
        symbols: {
          padding_group_digits: 4,
        },
      )

      expect(options.padding_digits).to eq(0)
      expect(options.padding_group_digits).to eq(4)
    end

    it "rejects padding width options that are used together" do
      expect do
        described_class.new(
          symbols: {
            padding_digits: 6,
            padding_group_digits: 4,
          },
        )
      end.to raise_error(
        Plurimath::ConfigurationError,
        "formatter options cannot be used together: choose either " \
        ":padding_digits or :padding_group_digits",
      )
    end

    it "rejects padding width options that are both provided with non-positive values" do
      expect do
        described_class.new(
          symbols: {
            padding_digits: -6,
            padding_group_digits: -4,
          },
        )
      end.to raise_error(
        Plurimath::ConfigurationError,
        "formatter options cannot be used together: choose either " \
        ":padding_digits or :padding_group_digits",
      )
    end
  end
end
