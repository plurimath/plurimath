# frozen_string_literal: true

require "spec_helper"

RSpec.describe Plurimath::Formatter::Numbers::FormatOptions do
  describe "#initialize" do
    it "normalizes notation option values" do
      precision_resolver = double(resolve: 4)
      options = described_class.new(
        "14000",
        symbols: {
          decimal: "@",
          group: "_",
          group_digits: 2,
          base: 16,
          base_prefix: "16#",
          number_sign: :plus,
        },
        format: {
          notation: "scientific",
          e: "E",
          times: "x",
          exponent_sign: "plus",
        },
        precision: nil,
        precision_resolver: precision_resolver,
      )

      expect(options.notation).to eq(:scientific)
      expect(options.exponent_separator).to eq(:E)
      expect(options.times).to eq(:x)
      expect(options.exponent_sign).to eq(:plus)
      expect(options.precision).to eq(4)
      expect(options.decimal).to eq("@")
      expect(options.group).to eq("_")
      expect(options.group_digits).to eq(2)
      expect(options.base).to eq(16)
      expect(options.base_prefix).to eq("16#")
      expect(options).to be_base_prefix
      expect(options.number_sign).to eq(:plus)
    end

    it "uses notation defaults and delegates precision resolution" do
      precision_resolver = double(resolve: 2)
      format = {}

      options = described_class.new(
        "0.00",
        format: format,
        precision: nil,
        precision_resolver: precision_resolver,
      )

      expect(precision_resolver).to have_received(:resolve).with(
        "0.00",
        precision: nil,
        format: format,
        notation: nil,
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
    end
  end
end
